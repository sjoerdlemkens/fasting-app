import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/home/home.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:fasting_repository/fasting_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = context.read<SettingsRepository>();
    final fastingRepo = context.read<FastingRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(
            settingsRepo: settingsRepo,
          ),
        ),
        BlocProvider<FastingBloc>(
          create: (context) => FastingBloc(
            settingsRepo: settingsRepo,
            fastingRepo: fastingRepo,
          ),
        ),
      ],
      child: HomeView(),
    );
  }
}
