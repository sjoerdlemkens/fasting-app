import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentFastingSessionInitialView extends StatelessWidget {
  const CurrentFastingSessionInitialView({super.key});

  void _onStartFastPressed(BuildContext context) {
    final fastingBloc = context.read<CurrentFastingSessionBloc>();
    fastingBloc.add(FastStarted());
  }

  String _getFastingWindowLabel(FastingWindow window) {
    return switch (window) {
      FastingWindow.sixteenEight => '16:8 Intermittent',
      FastingWindow.eighteenSix => '18:6 Intermittent',
      FastingWindow.omad => 'OMAD',
    };
  }

  void _onPlanCardTap(BuildContext context, FastingWindow window) {
    final settingsBloc = context.read<SettingsBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: settingsBloc,
          child: FastingPlanSelectionView(
            currentWindow: window,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return BlocBuilder<CurrentFastingSessionBloc, CurrentFastingSessionState>(
      builder: (context, fastingState) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            // Default to 18:6 if settings not loaded yet
            final fastingWindow = settingsState is SettingsLoaded
                ? settingsState.settings.fastingWindow
                : FastingWindow.eighteenSix;
            final duration = fastingWindow.duration;
            // Recalculate end time on every build (triggered by bloc timer)
            final now = DateTime.now();
            final endTime = now.add(duration);

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Fasting Info with "Tap to begin" circle
                  Center(
                    child: ReadyFastInfo(
                      duration: duration,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Start Time Card
                  StartTimeCard(
                    startTime: null,
                    iconColor: color,
                  ),
                  const SizedBox(height: 12),
                  // End Time Card
                  EndTimeCard(
                    endTime: endTime,
                    iconColor: color,
                  ),
                  const SizedBox(height: 12),
                  // Current Plan Card
                  Card(
                    child: InkWell(
                      onTap: () => _onPlanCardTap(context, fastingWindow),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 72),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.view_list_outlined,
                                color: color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Current Plan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getFastingWindowLabel(fastingWindow),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Start Fast Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _onStartFastPressed(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Start Fast',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

