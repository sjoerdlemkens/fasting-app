import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:intl/intl.dart';

class FastingInProgressView extends StatelessWidget {
  final FastingInProgress state;

  const FastingInProgressView(this.state, {super.key});

  void _onEndFastPressed(BuildContext context) {
    final fastingBloc = context.read<FastingBloc>();
    fastingBloc.add(FastEnded());
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dayPrefix;
    if (dateToCheck == today) {
      dayPrefix = 'Today';
    } else if (dateToCheck == tomorrow) {
      dayPrefix = 'Tomorrow';
    } else {
      dayPrefix = DateFormat('MMM d').format(dateTime);
    }

    final time = DateFormat('hh:mm a').format(dateTime);
    return '$dayPrefix, $time';
  }

  String _getFastingWindowLabel(session) {
    if (session.window == null) return 'Custom';

    return switch (session.window!) {
      _ when session.window!.duration == const Duration(hours: 16) =>
        '16:8 Intermittent',
      _ when session.window!.duration == const Duration(hours: 18) =>
        '18:6 Intermittent',
      _ when session.window!.duration == const Duration(hours: 23) => 'OMAD',
      _ => 'Custom',
    };
  }

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: 
         Column(
          children: [
            const SizedBox(height: 16),
            ActiveFastInfo(session),
            const SizedBox(height: 32),
            _InfoCard(
              icon: Icons.play_circle_outline,
              iconColor: theme.colorScheme.primary,
              label: 'Start Time',
              value: _formatDateTime(session.start),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.flag_outlined,
              iconColor: theme.colorScheme.primary,
              label: 'Target End',
              value: _formatDateTime(session.endsOn),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.view_list_outlined,
              iconColor: theme.colorScheme.primary,
              label: 'Current Plan',
              value: _getFastingWindowLabel(session),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _onEndFastPressed(context),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 20),
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
            const SizedBox(height: 32),
          ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
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
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
