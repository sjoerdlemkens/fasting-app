import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/history/history.dart';
import 'package:fasting_app/fasting/edit_fasting_session/edit_fasting_session.dart';

class LastFastsSection extends StatelessWidget {
  final List<FastingSession> lastFasts;

  const LastFastsSection({
    super.key,
    required this.lastFasts,
  });

  Future<void> _onFastCardTap(
    BuildContext context,
    FastingSession session,
  ) async {
    if (session.id == null) return;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditFastingSessionView(sessionId: session.id!),
      ),
    );

    // Refresh history if something changed
    if (result == true) {
      final historyBloc = context.read<HistoryBloc>();
      final currentState = historyBloc.state;
      if (currentState is HistoryLoaded) {
        historyBloc.add(LoadHistoryMonth(currentState.currentMonth));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lastFasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Last Fasts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...lastFasts.map((session) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FastCard(
                session: session,
                onTap: () => _onFastCardTap(context, session),
              ),
            )),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AllFastsView(),
                ),
              );
            },
            child: const Text(
              'View All Fasts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4DB6AC), // primary green
              ),
            ),
          ),
        ),
      ],
    );
  }
}
