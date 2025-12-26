import 'package:fasting_app/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Calendar card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: SizedBox(
              height: 320, // Fixed height for calendar
              child: FastingCalendar(
                currentMonth: state.currentMonth,
                fastingSessionsByDay: state.fastingSessionsByDay,
                activeFast: state.activeFast,
                onPreviousMonth: () => _onPreviousMonthPressed(context),
                onNextMonth: () => _onNextMonthPressed(context),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Last Fasts section
          LastFastsSection(lastFasts: state.lastFasts),
        ],
      ),
    );
  }
}
