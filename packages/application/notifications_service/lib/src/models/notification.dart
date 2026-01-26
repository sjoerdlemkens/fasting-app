class Notification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledAt;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });
}
