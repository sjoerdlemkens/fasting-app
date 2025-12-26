import 'package:flutter/material.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

class SettingsLoadedView extends StatelessWidget {
  final SettingsLoaded state;

  const SettingsLoadedView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final settings = state.settings;

    return Container(
      color: const Color(0xFFF8F8F8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            // Preferences Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Text(
                'Fasting',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200]!.withOpacity(0.5),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SettingsListItem(
                    icon: Icons.schedule,
                    title: 'Fasting Plan',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<SettingsBloc>(),
                            child: FastingPlanSelectionView(
                              currentWindow: settings.fastingWindow,
                            ),
                          ),
                        ),
                      );
                    },
                    trailing: Text(
                      _getFastingPlanDisplayName(settings.fastingWindow),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Notifications Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200]!.withOpacity(0.5),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: SettingsListItem(
                icon: Icons.notifications_outlined,
                title: 'Enable Notifications',
                trailing: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 50,
                    height: 10,
                    child: Switch(
                      value: settings.notificationsEnabled,
                      onChanged: (enabled) {
                        context.read<SettingsBloc>().add(
                              UpdateNotificationsEnabled(enabled),
                            );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFastingPlanDisplayName(FastingWindow window) {
    return switch (window) {
      FastingWindow.sixteenEight => '16:8 Intermittent Fast',
      FastingWindow.eighteenSix => '18:6 Intermittent Fast',
      FastingWindow.omad => 'One Meal A Day (OMAD)',
    };
  }
}
