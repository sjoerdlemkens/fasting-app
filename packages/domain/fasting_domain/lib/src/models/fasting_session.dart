import 'package:fasting_domain/fasting_domain.dart';

class FastingSession {
  final int? id;
  final DateTime start;
  final DateTime? end;
  final FastingWindow? window;

  const FastingSession({
    this.id,
    required this.window,
    required this.start,
    this.end,
  });

  /// Whether the fast is currently ongoing.
  bool get isActive => end == null;

  /// End time of the fast based on the window
  DateTime get endsOn =>
      window == null ? DateTime.now() : start.add(window!.duration);

  /// Duration so far (active) or total duration (completed).
  Duration get elapsed => (end ?? DateTime.now()).difference(start);

  /// Duration remaining to reach the fasting goal.
  Duration get remaining {
    if (window == null) return Duration.zero;

    final remainingDuration = window!.duration - elapsed;
    return remainingDuration.isNegative ? Duration.zero : remainingDuration;
  }

  /// Calculate progress as a percentage (0.0 to 1.0).
  double get progress {
    if (window == null) return 0.0;

    return (elapsed.inMilliseconds / window!.duration.inMilliseconds).clamp(
      0.0,
      1.0,
    );
  }

  /// Check if the fasting goal has been achieved.
  bool get isGoalAchieved => window != null && elapsed >= window!.duration;

  /// Create a copy with changes (immutable pattern).
  FastingSession copyWith({
    int? id,
    DateTime? start,
    DateTime? end,
    FastingWindow? window,
  }) {
    return FastingSession(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      window: window ?? this.window,
    );
  }
}
