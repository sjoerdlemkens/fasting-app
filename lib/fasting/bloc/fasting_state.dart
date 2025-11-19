part of 'fasting_bloc.dart';

@immutable
sealed class FastingState extends Equatable {
  const FastingState();

  @override
  List<Object?> get props => [];
}

final class FastingInitial extends FastingState {
  const FastingInitial();
}

final class FastingInProgress extends FastingState {
  final Duration elapsed;

  const FastingInProgress({this.elapsed = Duration.zero});

  @override
  List<Object?> get props => [elapsed];
}
