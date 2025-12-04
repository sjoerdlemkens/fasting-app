import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FastingInitialView extends StatelessWidget {
  const FastingInitialView({super.key});

  void _onStartFastPressed(BuildContext context) {
    final fastingBloc = context.read<FastingBloc>();
    fastingBloc.add(FastStarted());
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            // Fasting Info
            Center(
              child: ReadyFastInfo(
                duration: Duration(hours: 16), // TODO: Make dynamic
              ),
            ),

            // Start Fast Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onStartFastPressed(context),
                child: const Text('Start Fast'),
              ),
            ),

            const SizedBox(height: 24),

            // Start and End Time Row
            FastingStartEndRow(
              start: null,
              end: DateTime.now().add(
                Duration(hours: 16),
              ),
            ),
          ],
        ),
      );
}
