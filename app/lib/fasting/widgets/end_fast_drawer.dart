import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_repository/fasting_repository.dart';

class EndFastDrawer extends StatelessWidget {
  final FastingSession session;

  const EndFastDrawer({
    required this.session,
    super.key,
  });

  static void show(BuildContext context, FastingSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<FastingBloc>(),
        child: EndFastDrawer(session: session),
      ),
    );
  }

  void _onEndFastPressed(BuildContext context) {
    final fastingBloc = context.read<FastingBloc>();
    fastingBloc.add(FastEnded());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('End Fast'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _onEndFastPressed(context),
                    child: const Text('End Fast'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
