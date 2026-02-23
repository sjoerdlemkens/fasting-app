import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';
import 'package:fasting_app/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/home/home.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:notifications_service/notifications_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = context.read<SettingsRepository>();
    final fastingRepo = context.read<FastingRepository>();
    final notificationsRepo = context.read<NotificationsRepository>();
    final notificationsService = context.read<NotificationsService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          lazy: false,
          create: (context) => SettingsBloc(
            settingsRepo: settingsRepo,
          )..add(LoadSettings()),
        ),
        BlocProvider<CurrentFastingSessionBloc>(
          create: (context) => CurrentFastingSessionBloc(
            fastingRepo: fastingRepo,
            settingsRepo: settingsRepo,
            notificationsRepository: notificationsRepo,
            notificationsService: notificationsService,
          )..add(LoadActiveFast()),
        ),
      ],
      child: HomeView(),
    );
  }
}
