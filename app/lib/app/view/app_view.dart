import 'package:flutter/material.dart';
import 'package:fasting_app/l10n/app_localizations.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_app/home/home.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Itermino',
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      );
}
