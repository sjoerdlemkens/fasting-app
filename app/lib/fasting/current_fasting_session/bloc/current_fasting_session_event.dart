part of 'current_fasting_session_bloc.dart';

@immutable
sealed class CurrentFastingSessionEvent {
  const CurrentFastingSessionEvent();
}

class FastStarted extends CurrentFastingSessionEvent {}

class FastEnded extends CurrentFastingSessionEvent {}

class LoadActiveFast extends CurrentFastingSessionEvent {}

class UpdateActiveFastWindow extends CurrentFastingSessionEvent {
  final FastingWindow window;

  const UpdateActiveFastWindow(this.window);
}

class UpdateActiveFastStartTime extends CurrentFastingSessionEvent {
  final DateTime startTime;

  const UpdateActiveFastStartTime(this.startTime);
}

class _TimerTicked extends CurrentFastingSessionEvent {
  final Duration duration;

  const _TimerTicked({required this.duration});
}

class _PreviewTimerTicked extends CurrentFastingSessionEvent {
  const _PreviewTimerTicked();
}

