import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

class SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsListItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[100]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[400],
              size: 24,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 16,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: AppSpacing.sm),
            ],
            if (onTap != null && trailing == null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

