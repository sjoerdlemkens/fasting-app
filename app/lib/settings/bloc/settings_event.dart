part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateFastingWindow extends SettingsEvent {
  final FastingWindow fastingWindow;

  const UpdateFastingWindow(this.fastingWindow);

  @override
  List<Object> get props => [fastingWindow];
}
