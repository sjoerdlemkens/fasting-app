part of 'history_bloc.dart';

@immutable
sealed class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final DateTime currentMonth;
  final Map<DateTime, List<FastingSession>> fastingSessionsByDay;

  const HistoryLoaded({
    required this.currentMonth,
    required this.fastingSessionsByDay,
  });
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);
}
