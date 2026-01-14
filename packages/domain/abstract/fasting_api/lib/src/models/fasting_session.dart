class FastingSession {
  final int? id;
  final DateTime start;
  final DateTime? end;
  final int? window;

  FastingSession({
    required this.id,
    required this.start,
    required this.end,
    required this.window,
  });
}
