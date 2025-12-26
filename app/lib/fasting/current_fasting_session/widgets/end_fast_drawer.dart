import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';
import 'package:fasting_app/app/theme/app_radius.dart';

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
        value: context.read<CurrentFastingSessionBloc>(),
        child: EndFastDrawer(session: session),
      ),
    );
  }

  void _onEndFastPressed(BuildContext context) {
    final fastingBloc = context.read<CurrentFastingSessionBloc>();
    fastingBloc.add(FastEnded());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('End Fast'),
                const SizedBox(height: AppSpacing.xl),
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

