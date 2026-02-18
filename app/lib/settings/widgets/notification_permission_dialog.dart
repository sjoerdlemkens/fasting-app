import 'package:flutter/material.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({
    super.key,
  });

  static Future<void> show(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (context) => NotificationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Notification Permissions'),
        content:
            const Text('Enable notifications in app settings to receive fasting reminders.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
}
