part of 'edit_fasting_session_bloc.dart';

@immutable
sealed class EditFastingSessionState {
  const EditFastingSessionState();
}

class EditFastingSessionInitial extends EditFastingSessionState {
  const EditFastingSessionInitial();
}

class EditFastingSessionLoading extends EditFastingSessionState {
  const EditFastingSessionLoading();
}

class EditFastingSessionLoaded extends EditFastingSessionState {
  final FastingSession session;

  const EditFastingSessionLoaded(this.session);
}

class EditFastingSessionUpdating extends EditFastingSessionState {
  final FastingSession session;

  const EditFastingSessionUpdating(this.session);
}

class EditFastingSessionDeleting extends EditFastingSessionState {
  const EditFastingSessionDeleting();
}

class EditFastingSessionDeleted extends EditFastingSessionState {
  const EditFastingSessionDeleted();
}

class EditFastingSessionError extends EditFastingSessionState {
  final String message;

  const EditFastingSessionError(this.message);
}

