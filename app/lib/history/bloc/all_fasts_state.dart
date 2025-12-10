part of 'all_fasts_bloc.dart';

@immutable
sealed class AllFastsState {
  const AllFastsState();
}

class AllFastsInitial extends AllFastsState {
  const AllFastsInitial();
}

class AllFastsLoading extends AllFastsState {
  const AllFastsLoading();
}

class AllFastsLoaded extends AllFastsState {
  final DateTime currentMonth;
  final List<FastingSession> fastingSessions;

  const AllFastsLoaded({
    required this.currentMonth,
    required this.fastingSessions,
  });
}

class AllFastsError extends AllFastsState {
  final String message;

  const AllFastsError(this.message);
}


