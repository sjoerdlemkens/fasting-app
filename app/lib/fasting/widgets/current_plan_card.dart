import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/settings/settings.dart';

class CurrentPlanCard extends StatelessWidget {
  final FastingSession session;
  final Color iconColor;

  const CurrentPlanCard({
    required this.session,
    this.iconColor = Colors.blue,
    super.key,
  });

  String _getFastingWindowLabel() {
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

  FastingWindow _getCurrentWindow() {
    // Use the session's window if available, otherwise default to sixteenEight
    return session.window ?? FastingWindow.sixteenEight;
  }

  void _onTap(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: settingsBloc,
          child: FastingPlanSelectionView(
            currentWindow: _getCurrentWindow(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        iconColor == Colors.blue ? theme.colorScheme.primary : iconColor;

    return Card(
      child: InkWell(
        onTap: () => _onTap(context),
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
                      _getFastingWindowLabel(),
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
    );
  }
}
