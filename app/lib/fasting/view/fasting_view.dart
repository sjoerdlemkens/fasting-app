import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/misc/misc.dart';
import 'package:fasting_app/fasting/fasting.dart';

class FastingView extends StatelessWidget {
  const FastingView({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BlocBuilder<FastingBloc, FastingState>(
            builder: (context, state) => switch (state) {
              FastingInitial() => FastingInitialView(),
              FastingLoading() => LoadingView(),
              FastingInProgress() => FastingInProgressView(state),
            },
          ),
        ),
      );
}
