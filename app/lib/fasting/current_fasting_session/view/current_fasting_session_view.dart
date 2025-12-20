import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/misc/misc.dart';
import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';

class CurrentFastingSessionView extends StatelessWidget {
  const CurrentFastingSessionView({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BlocBuilder<CurrentFastingSessionBloc,
              CurrentFastingSessionState>(
            builder: (context, state) => switch (state) {
              CurrentFastingSessionInitial() ||
              CurrentFastingSessionLoading() =>
                LoadingView(),
              CurrentFastingSessionReady() =>
                CurrentFastingSessionInitialView(),
              CurrentFastingSessionInProgress() =>
                CurrentFastingSessionInProgressView(state),
            },
          ),
        ),
      );
}

