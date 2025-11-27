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
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          Text(
            "Ready to fast?",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          // Fasting Info
          Expanded(
            child: Center(
              child: ReadyFastInfo(
                duration: Duration(hours: 16), // TODO: Make dynamic
              ),
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
      );
}
