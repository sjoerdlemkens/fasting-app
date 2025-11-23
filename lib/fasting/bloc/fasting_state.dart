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

final class FastingLoading extends FastingState {
  const FastingLoading();
}

final class FastingInProgress extends FastingState {
  final FastingWindow window;
  final DateTime started;
  final Duration elapsed;

  const FastingInProgress({
    required this.window,
    required this.started,
    this.elapsed = Duration.zero,
  });

  FastingInProgress copyWith({
    DateTime? started,
    Duration? elapsed,
    FastingWindow? window,
  }) {
    return FastingInProgress(
      window: window ?? this.window,
      started: started ?? this.started,
      elapsed: elapsed ?? this.elapsed,
    );
  }

  @override
  List<Object?> get props => [elapsed];
}
