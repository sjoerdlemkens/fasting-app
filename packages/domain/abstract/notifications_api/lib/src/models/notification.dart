class Notification {
  final int id;
  final String titleTKey;
  final String bodyTKey;
  final DateTime scheduledAt;

  Notification({
    required this.id,
    required this.titleTKey,
    required this.bodyTKey,
    required this.scheduledAt,
  });
}
