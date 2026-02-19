import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepo;

  StreamSubscription<bool>? _notificationsEnabledSubscription;

  SettingsBloc({
    required SettingsRepository settingsRepo,
  })  : _settingsRepo = settingsRepo,
        super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateFastingWindow>(_onUpdateFastingWindow);
    on<UpdateNotificationsEnabled>(_onUpdateNotificationsEnabled);

    _notificationsEnabledSubscription =
        _settingsRepo.notificationsEnabledStream.listen(
      (enabled) => add(UpdateNotificationsEnabled(enabled)),
    );
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    try {
      final fastingWindow = await _settingsRepo.getFastingWindow();
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

  Future<bool> _getNotificationsEnabled() async {
    final notificationsEnabled = await _settingsRepo.getNotificationsEnabled();
    final hasNotificationsPermission = await Permission.notification.request();

    if (!hasNotificationsPermission.isGranted) {
      if (notificationsEnabled) {
        _settingsRepo.setNotificationsEnabled(false);
      }

      return false;
    }

    return notificationsEnabled;
  }

  void _onUpdateFastingWindow(
    UpdateFastingWindow event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;

    if (currentState is SettingsLoaded) {
      try {
        await _settingsRepo.setFastingWindow(event.fastingWindow);

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
    final updatedNotificationsEnabled = event.enabled;
    final currentState = state;

    if (currentState is! SettingsLoaded) return;

    // Skip if value hasn't changed
    if (currentState.settings.notificationsEnabled ==
        updatedNotificationsEnabled) {
      return;
    }

    try {
      // If enabling, check for permission first
      if (updatedNotificationsEnabled) {
        final hasNotificationsPermission =
            await Permission.notification.request();

        if (!hasNotificationsPermission.isGranted) {
          emit(
            SettingsUpdateError(
              currentState.settings,
              SettingsError.notificationPermissionDenied,
            ),
          );
          return;
        }
      }

      await _settingsRepo.setNotificationsEnabled(updatedNotificationsEnabled);

      final updatedSettings = currentState.settings.copyWith(
        notificationsEnabled: updatedNotificationsEnabled,
      );

      if (!isClosed) {
        emit(SettingsLoaded(updatedSettings));
      }
    } catch (e) {
      log('Error updating notifications enabled: $e');
    }
  }

  @override
  Future<void> close() {
    _notificationsEnabledSubscription?.cancel();
    return super.close();
  }
}
