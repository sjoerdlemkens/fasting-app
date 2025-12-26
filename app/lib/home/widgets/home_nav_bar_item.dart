import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/app_radius.dart';

class HomeNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const HomeNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(label),
            ],
          ),
        ),
      );
}
