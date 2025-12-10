import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xff0f172b),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.25,
              letterSpacing: 0.15,
            ),
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xff0f172b)),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
      );
}


