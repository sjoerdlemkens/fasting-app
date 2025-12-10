part of 'fasting_bloc.dart';

@immutable
sealed class FastingEvent {
  const FastingEvent();
}

class FastStarted extends FastingEvent {}

class FastEnded extends FastingEvent {}

class LoadActiveFast extends FastingEvent {}

class UpdateActiveFastWindow extends FastingEvent {
  final FastingWindow window;

  const UpdateActiveFastWindow(this.window);
}

class _TimerTicked extends FastingEvent {
  final Duration duration;

  const _TimerTicked({required this.duration});
}
