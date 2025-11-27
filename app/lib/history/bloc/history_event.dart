part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {
  const HistoryEvent();
}

class LoadHistoryMonth extends HistoryEvent {
  final DateTime month;

  const LoadHistoryMonth(this.month);
}

class ChangeMonth extends HistoryEvent {
  final DateTime month;

  const ChangeMonth(this.month);
}
