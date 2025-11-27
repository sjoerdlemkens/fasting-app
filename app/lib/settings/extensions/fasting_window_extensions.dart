import 'package:fasting_repository/fasting_repository.dart';

extension FastingWindowDisplay on FastingWindow {
  String get displayName => switch (this) {
        FastingWindow.sixteenEight => '16:8',
        FastingWindow.eighteenSix => '18:6',
        FastingWindow.omad => 'OMAD',
      };
}
