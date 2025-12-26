import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/home/home.dart';
import 'package:fasting_app/history/history.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';
import 'package:fasting_app/app/theme/app_radius.dart';

class EditFastingSessionView extends StatelessWidget {
  final int sessionId;

  const EditFastingSessionView({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    final fastingRepository = context.read<FastingRepository>();

    return BlocProvider(
      create: (context) => EditFastingSessionBloc(
        getFastingSessionById: GetFastingSessionByIdUseCase(
          fastingRepo: fastingRepository,
        ),
        updateCompletedFast: UpdateCompletedFastUseCase(
          fastingRepo: fastingRepository,
        ),
        deleteFast: DeleteFastUseCase(
          fastingRepo: fastingRepository,
        ),
      )..add(LoadFastingSession(sessionId)),
      child: Scaffold(
        appBar: const HomeAppBar.withTitle('Fast Details'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: _EditFastingSessionViewContent(sessionId: sessionId),
          ),
        ),
      ),
    );
  }
}

class _EditFastingSessionViewContent extends StatelessWidget {
  final int sessionId;

  const _EditFastingSessionViewContent({required this.sessionId});

  void _onStartTimeChanged(
    BuildContext context,
    DateTime newStartTime,
    FastingSession currentSession,
  ) {
    final bloc = context.read<EditFastingSessionBloc>();
    bloc.add(UpdateFastingSessionTimes(
      startTime: newStartTime,
      endTime: currentSession.end,
    ));
  }

  void _onEndTimeChanged(
    BuildContext context,
    DateTime newEndTime,
    FastingSession currentSession,
  ) {
    final bloc = context.read<EditFastingSessionBloc>();
    bloc.add(UpdateFastingSessionTimes(
      startTime: currentSession.start,
      endTime: newEndTime,
    ));
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final confirmed = await ConfirmDeleteFastDialog.show(context);

    if (confirmed == true) {
      final bloc = context.read<EditFastingSessionBloc>();
      bloc.add(const DeleteFastingSession());
    }
  }

  void _handleDeleteSuccess(BuildContext context) {
    // Navigate back with result indicating deletion
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<EditFastingSessionBloc, EditFastingSessionState>(
      listenWhen: (previous, current) {
        // Listen to delete, errors, and updates (but not initial load)
        return current is EditFastingSessionDeleted ||
            current is EditFastingSessionError ||
            (previous is EditFastingSessionUpdating &&
                current is EditFastingSessionLoaded);
      },
      listener: (context, state) {
        if (state is EditFastingSessionDeleted) {
          _handleDeleteSuccess(context);
        } else if (state is EditFastingSessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is EditFastingSessionLoaded) {
          // Show success message for updates
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fast updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<EditFastingSessionBloc, EditFastingSessionState>(
        builder: (context, state) => switch (state) {
          EditFastingSessionInitial() ||
          EditFastingSessionLoading() =>
            const Center(child: CircularProgressIndicator()),
          EditFastingSessionError() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextButton(
                    onPressed: () {
                      final bloc = context.read<EditFastingSessionBloc>();
                      bloc.add(LoadFastingSession(sessionId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          EditFastingSessionLoaded() ||
          EditFastingSessionUpdating() =>
            _buildDetailContent(
              context,
              state is EditFastingSessionLoaded
                  ? state.session
                  : (state as EditFastingSessionUpdating).session,
              theme,
              state is EditFastingSessionUpdating,
            ),
          EditFastingSessionDeleting() => const Center(
              child: CircularProgressIndicator(),
            ),
          EditFastingSessionDeleted() => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    FastingSession session,
    ThemeData theme,
    bool isUpdating,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          CompletedFastInfo(session),
          const SizedBox(height: AppSpacing.xxl),
          StartTimeCard(
            startTime: session.start,
            iconColor: theme.colorScheme.primary,
            onStartTimeChanged: isUpdating
                ? null
                : (newStartTime) =>
                    _onStartTimeChanged(context, newStartTime, session),
          ),
          const SizedBox(height: AppSpacing.md),
          EditableEndTimeCard(
            endTime: session.end,
            iconColor: theme.colorScheme.primary,
            onEndTimeChanged: isUpdating
                ? null
                : (newEndTime) =>
                    _onEndTimeChanged(context, newEndTime, session),
          ),
          const SizedBox(height: AppSpacing.md),
          FastingPlanCard(
            session: session,
            iconColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isUpdating
                  ? null
                  : () => _showDeleteConfirmationDialog(context),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Delete Fast',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
