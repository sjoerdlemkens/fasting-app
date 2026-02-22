import 'dart:async';
import 'dart:developer';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:fasting_app/fasting/current_fasting_session/utils/utils.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:notifications_service/notifications_service.dart';
import 'package:settings_repository/settings_repository.dart';

part 'current_fasting_session_event.dart';
part 'current_fasting_session_state.dart';

class CurrentFastingSessionBloc
    extends Bloc<CurrentFastingSessionEvent, CurrentFastingSessionState> {
  final FastingRepository _fastingRepo;
  final SettingsRepository _settingsRepo;
  final NotificationsRepository _notificationsRepository;

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription<FastingWindow>? _fastingWindowsSettingsSub;
  Timer? _previewTimer;

  CurrentFastingSessionBloc({
    required FastingRepository fastingRepo,
    required SettingsRepository settingsRepo,
    required NotificationsRepository notificationsRepository,
    required NotificationsService notificationsService,
    Ticker ticker = const Ticker(),
  })  : _fastingRepo = fastingRepo,
        _settingsRepo = settingsRepo,
        _notificationsRepository = notificationsRepository,
        _ticker = ticker,
        super(const CurrentFastingSessionInitial()) {
    on<LoadActiveFast>(_onLoadActiveFast);
    on<FastStarted>(_onFastStarted);
    on<FastEnded>(_onFastEnded);
    on<FastCanceled>(_onFastCanceled);
    on<_TimerTicked>(_onTimerTicked);
    on<UpdateActiveFastWindow>(_onUpdateActiveFastWindow);
    on<UpdateActiveFastStartTime>(_onUpdateActiveFastStartTime);
    on<_PreviewTimerTicked>(_onPreviewTimerTicked);

// Listen to fasting window changes in settings to update active fast if needed
    _fastingWindowsSettingsSub =
        settingsRepo.fastingWindowStream.listen((fastingWindow) {
      add(UpdateActiveFastWindow(fastingWindow));
    });

    // Start preview timer for initial state
    _startPreviewTimer();
  }

  void _onLoadActiveFast(
    LoadActiveFast event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    emit(const CurrentFastingSessionLoading());

    try {
      // Get active fast (isActive: true, limit: 1)
      final sessions = await _fastingRepo.getFastingSessions(
        limit: 1,
        isActive: true,
      );
      var activeFastingSession = sessions.firstOrNull;

      if (activeFastingSession != null) {
        final fastingWindow = await _settingsRepo.getFastingWindow();

        activeFastingSession =
            activeFastingSession.copyWith(window: fastingWindow);

        final elapsed = DateTime.now().difference(activeFastingSession.start);
        _stopPreviewTimer();
        _startTicker(startFrom: elapsed);

        emit(CurrentFastingSessionInProgress(activeFastingSession));
      } else {
        _startPreviewTimer();
        emit(const CurrentFastingSessionReady());
      }
    } catch (e) {
      log(e.toString());
      _startPreviewTimer();
      emit(const CurrentFastingSessionReady());
    }
  }

  void _onFastStarted(
    FastStarted event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    // Get fasting window from settings
    final fastingWindow = await _settingsRepo.getFastingWindow();

    // Create fasting session in repository
    final createdSession = await _fastingRepo.createFastingSession(
      started: DateTime.now(),
    );
    final fastingSession = createdSession.copyWith(window: fastingWindow);

    // Now create a notification for the fasting session
    final notification = await _notificationsRepository.createNotification(
      titleTKey: 'fastCompletedNotificationTitle',
      bodyTKey: 'fastCompletedNotificationBody',
      scheduledAt: fastingSession.endsOn,
    );

    // Update the fasting session with the window and notification id
    final updatedFastingSession = await _fastingRepo.updateFastingSession(
      id: fastingSession.id!,
      window: fastingWindow,
      notificationId: notification.id,
    );

    _stopPreviewTimer();
    _startTicker();

    emit(
      CurrentFastingSessionInProgress(updatedFastingSession),
    );
  }

  void _startTicker({Duration startFrom = Duration.zero}) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen(
          (seconds) => add(
            _TimerTicked(
              duration: startFrom + Duration(seconds: seconds),
            ),
          ),
        );
  }

  void _startPreviewTimer() {
    _stopPreviewTimer();
    // Update every minute to refresh the end time preview
    _previewTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (state is CurrentFastingSessionReady) {
        add(const _PreviewTimerTicked());
      }
    });
  }

  void _stopPreviewTimer() {
    _previewTimer?.cancel();
    _previewTimer = null;
  }

  void _onFastEnded(
    FastEnded event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    final state = this.state;
    if (state is! CurrentFastingSessionInProgress) return;

    final fastId = state.session.id!;

    // Get fasting window from settings and update the session
    final fastingWindow = await _settingsRepo.getFastingWindow();
    await _fastingRepo.updateFastingSession(
      id: fastId,
      end: event.endTime,
      window: fastingWindow,
    );

    await _notificationsRepository.deleteNotification(fastId);

    _tickerSubscription?.cancel();
    _startPreviewTimer();
    emit(const CurrentFastingSessionReady());
  }

  void _onFastCanceled(
    FastCanceled event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    final state = this.state;
    if (state is! CurrentFastingSessionInProgress) return;

    final fastingSession = state.session;

    await _fastingRepo.deleteFastingSession(fastingSession.id!);

    // If it has a notification, cancel it
    if (fastingSession.notificationId != null) {
      await _notificationsRepository
          .deleteNotification(fastingSession.notificationId!);
    }

    _tickerSubscription?.cancel();
    _startPreviewTimer();

    emit(const CurrentFastingSessionReady());
  }

  void _onTimerTicked(
      _TimerTicked event, Emitter<CurrentFastingSessionState> emit) {
    if (state is! CurrentFastingSessionInProgress) return;

    final currentState = state as CurrentFastingSessionInProgress;
    // Create a state copy to trigger UI updates on each tick
    final newState = currentState.copyWith();

    emit(newState);
  }

  void _onPreviewTimerTicked(
    _PreviewTimerTicked event,
    Emitter<CurrentFastingSessionState> emit,
  ) {
    if (state is! CurrentFastingSessionReady) return;

    // Emit a new CurrentFastingSessionReady state to trigger UI rebuild
    emit(const CurrentFastingSessionReady());
  }

  Future<void> _onUpdateActiveFastWindow(
    UpdateActiveFastWindow event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CurrentFastingSessionInProgress) return;

    // Only update if the window has actually changed
    if (currentState.session.window == event.window) return;

    try {
      // Get the active fast
      final activeSessions = await _fastingRepo.getFastingSessions(
        isActive: true,
        limit: 1,
      );

      if (activeSessions.isEmpty) return;

      final activeSession = activeSessions.first;
      if (activeSession.id == null) return;

      // Update the window
      final updatedSession = await _fastingRepo.updateFastingSession(
        id: activeSession.id!,
        window: event.window,
      );

      emit(CurrentFastingSessionInProgress(updatedSession));
    } catch (e) {
      // On error, keep the current state unchanged
      // Could emit an error state if needed
    }
  }

  Future<void> _onUpdateActiveFastStartTime(
    UpdateActiveFastStartTime event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CurrentFastingSessionInProgress) return;

    // // Only update if the start time has actually changed
    // if (currentState.session.start == event.startTime) return;

    try {
      // Validate that the start time is not in the future
      final now = DateTime.now();
      if (event.startTime.isAfter(now)) {
        return;
      }

      // Get the active fast
      final activeSessions = await _fastingRepo.getFastingSessions(
        isActive: true,
        limit: 1,
      );

      if (activeSessions.isEmpty) return;

      final activeSession = activeSessions.first;
      if (activeSession.id == null) return;

      // Update the start time
      final updatedSession = await _fastingRepo.updateFastingSession(
        id: activeSession.id!,
        start: event.startTime,
      );

      // Recalculate elapsed time and restart ticker
      final elapsed = DateTime.now().difference(updatedSession.start);
      _startTicker(startFrom: elapsed);
      emit(CurrentFastingSessionInProgress(updatedSession));
    } catch (e) {
      print(e);
      // On error, keep the current state unchanged
      // Could emit an error state if needed
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    _fastingWindowsSettingsSub?.cancel();
    _stopPreviewTimer();
    return super.close();
  }
}
