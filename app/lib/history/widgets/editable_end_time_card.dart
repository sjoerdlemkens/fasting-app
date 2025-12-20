import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditableEndTimeCard extends StatelessWidget {
  final DateTime? endTime;
  final Color iconColor;
  final ValueChanged<DateTime>? onEndTimeChanged;

  const EditableEndTimeCard({
    this.endTime,
    this.iconColor = Colors.blue,
    this.onEndTimeChanged,
    super.key,
  });

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Not set';
    }

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

  Future<void> _showTimePickerDialog(BuildContext context) async {
    if (endTime == null || onEndTimeChanged == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTime!),
    );

    if (pickedTime == null) return;

    final newEndTime = DateTime(
      endTime!.year,
      endTime!.month,
      endTime!.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onEndTimeChanged!(newEndTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        iconColor == Colors.blue ? theme.colorScheme.primary : iconColor;

    return Card(
      child: InkWell(
        onTap: onEndTimeChanged != null
            ? () => _showTimePickerDialog(context)
            : null,
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
                  Icons.flag_outlined,
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
                      'End Time',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDateTime(endTime),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (onEndTimeChanged != null)
                Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

