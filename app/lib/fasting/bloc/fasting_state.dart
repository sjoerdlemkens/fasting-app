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

final class FastingInProgress extends FastingState {
  final FastingSession session;

  const FastingInProgress(this.session);

  FastingInProgress copyWith({
    FastingSession? session,
  }) =>
      FastingInProgress(session ?? this.session);
}
