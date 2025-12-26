import 'package:equatable/equatable.dart';
import 'package:fasting_repository/fasting_repository.dart';

class Settings extends Equatable {
  final FastingWindow fastingWindow;
  final bool notificationsEnabled;

  const Settings({
    required this.fastingWindow,
    this.notificationsEnabled = true,
  });

  @override
  List<Object> get props => [fastingWindow, notificationsEnabled];

  Settings copyWith({
    FastingWindow? fastingWindow,
    bool? notificationsEnabled,
  }) {
    return Settings(
      fastingWindow: fastingWindow ?? this.fastingWindow,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
