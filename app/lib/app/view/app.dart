import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/app/app.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:notifications_service/notifications_service.dart';

class App extends StatelessWidget {
  final FastingRepository Function() createFastingRepo;
  final SettingsRepository Function() createSettingsRepo;
  final NotificationsService notificationsService;

  const App({
    super.key,
    required this.createFastingRepo,
    required this.createSettingsRepo,
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
        RepositoryProvider<NotificationsService>(
          create: (context) => notificationsService,
        ),
      ],
      child: AppView(),
    );
  }
}
