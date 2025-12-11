import 'package:fasting_domain/fasting_domain.dart';

extension FastingWindowExtensions on FastingWindow {
  Duration get duration => switch (this) {
    FastingWindow.sixteenEight => const Duration(hours: 16),
    FastingWindow.eighteenSix => const Duration(hours: 18),
    FastingWindow.omad => const Duration(hours: 23),
  };
}
