part of 'fasting_bloc.dart';

@immutable
sealed class FastingState {
  const FastingState();
}

final class FastingInitial extends FastingState {
  const FastingInitial();
}

final class FastingInProgress extends FastingState {
  final Duration elapsed;

  const FastingInProgress({this.elapsed = Duration.zero});
}
