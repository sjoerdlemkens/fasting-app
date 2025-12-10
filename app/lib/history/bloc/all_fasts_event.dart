part of 'all_fasts_bloc.dart';

@immutable
sealed class AllFastsEvent {
  const AllFastsEvent();
}

class LoadAllFastsMonth extends AllFastsEvent {
  final DateTime month;

  const LoadAllFastsMonth(this.month);
}

class ChangeAllFastsMonth extends AllFastsEvent {
  final DateTime month;

  const ChangeAllFastsMonth(this.month);
}


