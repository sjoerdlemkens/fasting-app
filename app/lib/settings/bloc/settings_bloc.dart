import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetFastingWindowUseCase _getFastingWindow;
  final SetFastingWindowUseCase _setFastingWindow;
  final GetNotificationsEnabledUseCase _getNotificationsEnabled;
  final SetNotificationsEnabledUseCase _setNotificationsEnabled;

  SettingsBloc({
    required GetFastingWindowUseCase getFastingWindow,
    required SetFastingWindowUseCase setFastingWindow,
    required GetNotificationsEnabledUseCase getNotificationsEnabled,
    required SetNotificationsEnabledUseCase setNotificationsEnabled,
  })  : _getFastingWindow = getFastingWindow,
        _setFastingWindow = setFastingWindow,
        _getNotificationsEnabled = getNotificationsEnabled,
        _setNotificationsEnabled = setNotificationsEnabled,
        super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateFastingWindow>(_onUpdateFastingWindow);
    on<UpdateNotificationsEnabled>(_onUpdateNotificationsEnabled);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    try {
      final fastingWindow = await _getFastingWindow();
      final notificationsEnabled = await _getNotificationsEnabled();
      final settings = Settings(
        fastingWindow: fastingWindow,
        notificationsEnabled: notificationsEnabled,
      );

      if (!isClosed) {
        emit(SettingsLoaded(settings));
      }
    } catch (_) {
      // Fallback to initial state on error and maybe log the error
      if (!isClosed) {
        emit(SettingsInitial());
      }
    }
  }

  void _onUpdateFastingWindow(
      UpdateFastingWindow event, Emitter<SettingsState> emit) async {
    final currentState = state;

    if (currentState is SettingsLoaded) {
      try {
        await _setFastingWindow(event.fastingWindow);

        final updatedSettings = currentState.settings.copyWith(
          fastingWindow: event.fastingWindow,
        );

        if (!isClosed) {
          emit(SettingsLoaded(updatedSettings));
        }
      } catch (_) {
        // On error, keep the current state unchanged
        // Could emit an error state if needed
      }
    }
  }

  void _onUpdateNotificationsEnabled(
      UpdateNotificationsEnabled event, Emitter<SettingsState> emit) async {
    final currentState = state;

    if (currentState is SettingsLoaded) {
      try {
        await _setNotificationsEnabled(event.enabled);

        final updatedSettings = currentState.settings.copyWith(
          notificationsEnabled: event.enabled,
        );

        if (!isClosed) {
          emit(SettingsLoaded(updatedSettings));
        }
      } catch (_) {
        // On error, keep the current state unchanged
        // Could emit an error state if needed
      }
    }
  }
}
