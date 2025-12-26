import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';
import 'package:fasting_app/app/theme/app_radius.dart';

class CompletedFastInfo extends StatelessWidget {
  final FastingSession session;

  const CompletedFastInfo(
    this.session, {
    super.key,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final duration = session.elapsed;
    final durationText = _formatDuration(duration);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total Fasting Time',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            durationText,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937), // gray-900
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

