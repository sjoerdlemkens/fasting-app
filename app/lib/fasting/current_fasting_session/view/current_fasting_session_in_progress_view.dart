import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

class CurrentFastingSessionInProgressView extends StatelessWidget {
  final CurrentFastingSessionInProgress state;

  const CurrentFastingSessionInProgressView(this.state, {super.key});

  void _onEndFastPressed(BuildContext context) => EndFastDrawer.show(
        context,
        state.session,
      );

  void _onStartTimeChanged(BuildContext context, DateTime newStartTime) {
    final fastingBloc = context.read<CurrentFastingSessionBloc>();
    fastingBloc.add(UpdateActiveFastStartTime(newStartTime));
  }

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          ActiveFastInfo(session),
          const SizedBox(height: AppSpacing.xxl),
          StartTimeCard(
            startTime: session.start,
            iconColor: theme.colorScheme.primary,
            onStartTimeChanged: (newStartTime) =>
                _onStartTimeChanged(context, newStartTime),
          ),
          const SizedBox(height: AppSpacing.md),
          EndTimeCard(
            endTime: session.endsOn,
            iconColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          CurrentPlanCard(
            session: session,
            iconColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _onEndFastPressed(context),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'End Fast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
