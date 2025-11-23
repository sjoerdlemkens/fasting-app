
import 'package:fasting_entities/fasting_entities.dart';

class FastingSession {
  final int? id;
  final DateTime start;
  final DateTime? end;
  final FastingWindow window;

  const FastingSession({
    this.id,
    required this.window,
    required this.start,
    this.end,
  });

  /// Whether the fast is currently ongoing.
  bool get isActive => end == null;

  /// Duration so far (active) or total duration (completed).
  Duration get duration =>
      (end ?? DateTime.now()).difference(start);

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
