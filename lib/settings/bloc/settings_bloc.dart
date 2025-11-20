import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepo;

  SettingsBloc({required SettingsRepository settingsRepo})
      : _settingsRepo = settingsRepo,
        super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    // TODO: Load settings from the repository
    await Future.delayed(Duration(seconds: 1));
    final settings = Settings(); 

    if (!isClosed) {
      emit(SettingsLoaded(settings));
    }
  }
}
