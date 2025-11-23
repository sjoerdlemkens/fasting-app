import 'package:fasting_entities/fasting_entities.dart';

extension FastingWindowMappers on FastingWindow {
  /// Get integer value for database storage
  int toInt() => switch (this) {
    FastingWindow.sixteenEight => 0,
    FastingWindow.eighteenSix => 1,
    FastingWindow.omad => 2,
  };

  /// Create FastingWindow from integer value
  static FastingWindow fromInt(int value) => switch (value) {
    0 => FastingWindow.sixteenEight,
    1 => FastingWindow.eighteenSix,
    2 => FastingWindow.omad,
    _ => throw ArgumentError('Invalid FastingWindow value: $value'),
  };
}