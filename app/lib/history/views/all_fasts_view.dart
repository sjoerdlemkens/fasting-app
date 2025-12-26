import 'package:fasting_app/history/history.dart';
import 'package:fasting_app/misc/misc.dart';
import 'package:fasting_app/home/home.dart';
import 'package:fasting_app/fasting/edit_fasting_session/edit_fasting_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

class AllFastsView extends StatelessWidget {
  const AllFastsView({super.key});

  @override
  Widget build(BuildContext context) {
    final fastingRepository = context.read<FastingRepository>();

    return BlocProvider(
      create: (context) => AllFastsBloc(
        getMonthlyHistory: GetMonthlyHistoryUseCase(
          fastingRepository: fastingRepository,
        ),
      )..add(LoadAllFastsMonth(DateTime.now())),
      child: Scaffold(
        appBar: const HomeAppBar.withTitle('All Fasts'),
        body: const _AllFastsViewContent(),
      ),
    );
  }
}

class _AllFastsViewContent extends StatelessWidget {
  const _AllFastsViewContent();

  void _onPreviousMonthPressed(BuildContext context, DateTime currentMonth) {
    final previousMonth = DateTime(
      currentMonth.year,
      currentMonth.month - 1,
    );

    final bloc = context.read<AllFastsBloc>();
    bloc.add(ChangeAllFastsMonth(previousMonth));
  }

  void _onNextMonthPressed(BuildContext context, DateTime currentMonth) {
    final nextMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
    );

    final bloc = context.read<AllFastsBloc>();
    bloc.add(ChangeAllFastsMonth(nextMonth));
  }

  Future<void> _onFastCardTap(
    BuildContext context,
    FastingSession session,
  ) async {
    if (session.id == null) return;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditFastingSessionView(sessionId: session.id!),
      ),
    );

    // Refresh all fasts if something changed
    if (result == true) {
      final bloc = context.read<AllFastsBloc>();
      final currentState = bloc.state;
      if (currentState is AllFastsLoaded) {
        bloc.add(LoadAllFastsMonth(currentState.currentMonth));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllFastsBloc, AllFastsState>(
      builder: (context, state) => switch (state) {
        AllFastsInitial() || AllFastsLoading() => const LoadingView(),
        AllFastsError() => Center(
            child: Text("error: ${state.message}"),
          ), // TODO: implement reusable error view
        AllFastsLoaded() => Column(
            children: [
              MonthSelector(
                currentMonth: state.currentMonth,
                onPreviousMonth: () =>
                    _onPreviousMonthPressed(context, state.currentMonth),
                onNextMonth: () =>
                    _onNextMonthPressed(context, state.currentMonth),
              ),
              Expanded(
                child: state.fastingSessions.isEmpty
                    ? const Center(
                        child: Text(
                          'No fasting sessions found for this month',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: state.fastingSessions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: FastCard(
                              session: state.fastingSessions[index],
                              onTap: () => _onFastCardTap(
                                context,
                                state.fastingSessions[index],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
      },
    );
  }
}
