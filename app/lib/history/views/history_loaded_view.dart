import 'package:fasting_app/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryLoadedView extends StatelessWidget {
  final HistoryLoaded state;

  const HistoryLoadedView(this.state, {super.key});

  void _onPreviousMonthPressed(BuildContext context) {
    final previousMonth = DateTime(
      state.currentMonth.year,
      state.currentMonth.month - 1,
    );

    final historyBloc = context.read<HistoryBloc>();
    historyBloc.add(ChangeMonth(previousMonth));
  }

  void _onNextMonthPressed(BuildContext context) {
    final nextMonth = DateTime(
      state.currentMonth.year,
      state.currentMonth.month + 1,
    );

    final historyBloc = context.read<HistoryBloc>();
    historyBloc.add(ChangeMonth(nextMonth));
  }

  @override
  Widget build(BuildContext context) => FastingCalendar(
        currentMonth: state.currentMonth,
        fastingSessionsByDay: state.fastingSessionsByDay,
        onPreviousMonth: () => _onPreviousMonthPressed(context),
        onNextMonth: () => _onNextMonthPressed(context),
      );
}
