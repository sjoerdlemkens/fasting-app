import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepo;

  SettingsBloc({required SettingsRepository settingsRepo})
      : _settingsRepo = settingsRepo,
        super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateFastingWindow>(_onUpdateFastingWindow);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    try {
      final settings = await _fetchSettings();

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
      final updatedSettings = currentState.settings.copyWith(
        fastingWindow: event.fastingWindow,
      );

      // TODO: Persist settings to repository
      // await _settingsRepo.saveSettings(updatedSettings);

      emit(SettingsLoaded(updatedSettings));
    }
  }

  Future<Settings> _fetchSettings() async {
    // TODO: Fetch settings from repository

    await Future.delayed(Duration(seconds: 1));
    final settings = Settings(
      fastingWindow: FastingWindow.eighteenSix,
    );

    return settings;
  }
}
