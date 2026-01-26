import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/app/app.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:notifications_service/notifications_service.dart';
import 'package:settings_repository/settings_repository.dart';

class App extends StatelessWidget {
  final FastingRepository Function() createFastingRepo;
  final SettingsRepository Function() createSettingsRepo;
  final NotificationsRepository Function() createNotificationsRepo;
  final NotificationsService notificationsService;

  const App({
    super.key,
    required this.createFastingRepo,
    required this.createSettingsRepo,
    required this.createNotificationsRepo,
    required this.notificationsService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FastingRepository>(
          create: (context) => createFastingRepo(),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => createSettingsRepo(),
        ),
        RepositoryProvider<NotificationsRepository>(
          create: (context) => createNotificationsRepo(),
        ),
        RepositoryProvider<NotificationsService>(
          create: (context) => notificationsService,
        ),
      ],
      child: AppView(),
    );
  }
}
