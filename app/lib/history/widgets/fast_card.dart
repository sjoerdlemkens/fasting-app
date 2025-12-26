import 'package:flutter/material.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:intl/intl.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';
import 'package:fasting_app/app/theme/app_radius.dart';

class FastCard extends StatelessWidget {
  final FastingSession session;
  final VoidCallback? onTap;

  const FastCard({
    super.key,
    required this.session,
    this.onTap,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final startFormatted = DateFormat('MMM d, h:mm a').format(start);
    final endFormatted = DateFormat('MMM d, h:mm a').format(end);
    return '$startFormatted - $endFormatted';
  }

  @override
  Widget build(BuildContext context) {
    final isGoalAchieved = session.isGoalAchieved;
    final iconColor = isGoalAchieved
        ? const Color(0xFF4DB6AC) // Green
        : const Color(0xFF8DB6FD); // Blue
    final iconBackgroundColor = isGoalAchieved
        ? const Color(0xFF4DB6AC).withOpacity(0.2)
        : const Color(0xFF8DB6FD).withOpacity(0.2);
    final icon = isGoalAchieved ? Icons.check_circle : Icons.update;

    final duration = session.elapsed;
    final durationText = _formatDuration(duration);

    final endTime = session.end ?? DateTime.now();
    final dateRangeText = _formatDateRange(session.start, endTime);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  durationText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937), // gray-900
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateRangeText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Chevron
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

