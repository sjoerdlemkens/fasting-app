import 'package:flutter/material.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_app/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:notifications_service/notifications_service.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:fasting_app/notifications/notifications.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) => BlocProvider<NotificationsBloc>(
        lazy: false,
        create: (context) => NotificationsBloc(
          notificationsRepo: context.read<NotificationsRepository>(),
          settingsRepo: context.read<SettingsRepository>(),
          notificationsService: context.read<NotificationsService>(),
        )..add(NotificationsCleanUpRequested()),
        child: MaterialApp(
          title: 'Itermino',
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const NotificationsListener(
            child: HomePage(),
          ),
        ),
      );
}
