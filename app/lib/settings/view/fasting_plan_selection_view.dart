import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';
import 'package:fasting_app/app/theme/app_radius.dart';

class FastingPlanSelectionView extends StatelessWidget {
  final FastingWindow currentWindow;

  const FastingPlanSelectionView({
    super.key,
    required this.currentWindow,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final selectedWindow = state is SettingsLoaded
            ? state.settings.fastingWindow
            : currentWindow;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8F8F8),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Choose Your Plan',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      _PlanOption(
                        icon: Icons.schedule,
                        title: '16:8 Intermittent Fast',
                        description:
                            'Great for beginners. Fast for 16 hours, eat within an 8-hour window.',
                        isSelected: selectedWindow == FastingWindow.sixteenEight,
                        onTap: () => _selectPlan(context, FastingWindow.sixteenEight),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PlanOption(
                        icon: Icons.timelapse,
                        title: '18:6 Intermittent Fast',
                        description:
                            'A step up. Fast for 18 hours, eat within a 6-hour window.',
                        isSelected: selectedWindow == FastingWindow.eighteenSix,
                        onTap: () => _selectPlan(context, FastingWindow.eighteenSix),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PlanOption(
                        icon: Icons.restaurant,
                        title: 'One Meal A Day (OMAD)',
                        description:
                            'For experienced fasters. Eat within a 1-hour window.',
                        isSelected: selectedWindow == FastingWindow.omad,
                        onTap: () => _selectPlan(context, FastingWindow.omad),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA3D5F7),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm Selection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.015,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectPlan(BuildContext context, FastingWindow window) {
    context.read<SettingsBloc>().add(UpdateFastingWindow(window));
  }
}

class _PlanOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA3D5F7)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA3D5F7)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFFA3D5F7) : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

