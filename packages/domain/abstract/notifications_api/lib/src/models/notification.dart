import 'package:equatable/equatable.dart';

class Notification extends Equatable {
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
  
  @override
  List<Object?> get props => [id, titleTKey, bodyTKey, scheduledAt];
}
