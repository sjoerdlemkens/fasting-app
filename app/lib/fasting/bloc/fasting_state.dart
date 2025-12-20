part of 'fasting_bloc.dart';

@immutable
sealed class FastingState {
  const FastingState();
}

final class FastingInitial extends FastingState {
  const FastingInitial();
}

final class FastingLoading extends FastingState {
  const FastingLoading();
}

final class FastingReady extends FastingState {
  const FastingReady();
}

final class FastingInProgress extends FastingState {
  final FastingSession session;
  final int? notificationId;

  const FastingInProgress(this.session, this.notificationId);

  FastingInProgress copyWith({
    FastingSession? session,
    int? notificationId,
  }) =>
      FastingInProgress(
        session ?? this.session,
        notificationId ?? this.notificationId,
      );
}
