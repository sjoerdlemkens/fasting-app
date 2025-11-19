import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/fasting.dart';

class FastingInProgressView extends StatelessWidget {
  final FastingInProgress state;

  const FastingInProgressView(this.state, {super.key});

  void _onEndFastPressed(BuildContext context) {
    final fastingBloc = context.read<FastingBloc>();
    fastingBloc.add(FastEnded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Text(
                "You're fasting!",
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
                  child: FastingInfo(),
                ),
              ),

              // End Fast Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onEndFastPressed(context),
                  child: const Text('End Fast'),
                ),
              ),

              const SizedBox(height: 24),

              // Start and End Time Row
              FastingStartEndRow(),
            ],
          ),
        ),
      ),
    );
  }
}
