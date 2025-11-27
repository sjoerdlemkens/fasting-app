import 'package:equatable/equatable.dart';
import 'package:fasting_repository/fasting_repository.dart';

class Settings extends Equatable {
  final FastingWindow fastingWindow;

  const Settings({
    required this.fastingWindow,
  });

  @override
  List<Object> get props => [fastingWindow];

  Settings copyWith({
    FastingWindow? fastingWindow,
  }) {
    return Settings(
      fastingWindow: fastingWindow ?? this.fastingWindow,
    );
  }
}
