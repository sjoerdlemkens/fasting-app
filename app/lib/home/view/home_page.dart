import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/home/home.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = context.read<SettingsRepository>();
    final fastingRepo = context.read<FastingRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          lazy: false,
          create: (context) => SettingsBloc(
            getFastingWindow: GetFastingWindowUseCase(
              settingsRepo: settingsRepo,
            ),
            setFastingWindow: SetFastingWindowUseCase(
              settingsRepo: settingsRepo,
            ),
          )..add(LoadSettings()),
        ),
        BlocProvider<FastingBloc>(
          create: (context) => FastingBloc(
            startFast: StartFastUseCase(
              fastingRepo: fastingRepo,
              settingsRepo: settingsRepo,
            ),
            endFast: EndFastUseCase(
              fastingRepo: fastingRepo,
              settingsRepo: settingsRepo,
            ),
            getActiveFast: GetActiveFastUseCase(
              fastingRepo: fastingRepo,
            ),
          )..add(LoadActiveFast()),
        ),
      ],
      child: HomeView(),
    );
  }
}
