part of 'edit_fasting_session_bloc.dart';

@immutable
sealed class EditFastingSessionEvent {
  const EditFastingSessionEvent();
}

class LoadFastingSession extends EditFastingSessionEvent {
  final int sessionId;

  const LoadFastingSession(this.sessionId);
}

class UpdateFastingSessionTimes extends EditFastingSessionEvent {
  final DateTime? startTime;
  final DateTime? endTime;

  const UpdateFastingSessionTimes({
    this.startTime,
    this.endTime,
  });
}

class DeleteFastingSession extends EditFastingSessionEvent {
  const DeleteFastingSession();
}

