part of 'settings_bloc.dart';

enum SettingsError {
  notificationPermissionDenied,
  unknown,
}

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

final class SettingsUpdateError extends SettingsLoaded {
  final SettingsError error;

  const SettingsUpdateError(super.settings, this.error);

  @override
  List<Object> get props => [settings, error];
}
