part of 'current_fasting_session_bloc.dart';

@immutable
sealed class CurrentFastingSessionState {
  const CurrentFastingSessionState();
}

final class CurrentFastingSessionInitial extends CurrentFastingSessionState {
  const CurrentFastingSessionInitial();
}

final class CurrentFastingSessionLoading extends CurrentFastingSessionState {
  const CurrentFastingSessionLoading();
}

final class CurrentFastingSessionReady extends CurrentFastingSessionState {
  const CurrentFastingSessionReady();
}

final class CurrentFastingSessionInProgress extends CurrentFastingSessionState {
  final FastingSession session;
  final int? notificationId;

  const CurrentFastingSessionInProgress(this.session, this.notificationId);

  CurrentFastingSessionInProgress copyWith({
    FastingSession? session,
    int? notificationId,
  }) =>
      CurrentFastingSessionInProgress(
        session ?? this.session,
        notificationId ?? this.notificationId,
      );
}

