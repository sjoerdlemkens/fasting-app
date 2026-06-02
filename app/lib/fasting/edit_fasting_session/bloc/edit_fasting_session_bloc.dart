import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:meta/meta.dart';

part 'edit_fasting_session_event.dart';
part 'edit_fasting_session_state.dart';

class EditFastingSessionBloc
    extends Bloc<EditFastingSessionEvent, EditFastingSessionState> {
  final FastingRepository _fastingRepo;

  EditFastingSessionBloc({
    required FastingRepository fastingRepo,
  })  : _fastingRepo = fastingRepo,
        super(const EditFastingSessionInitial()) {
    on<LoadFastingSession>(_onLoadFastingSession);
    on<UpdateFastingSessionTimes>(_onUpdateFastingSessionTimes);
    on<DeleteFastingSession>(_onDeleteFastingSession);
  }

  Future<void> _onLoadFastingSession(
    LoadFastingSession event,
    Emitter<EditFastingSessionState> emit,
  ) async {
    emit(const EditFastingSessionLoading());

    try {
      final session = await _fastingRepo.getFastingSessionById(event.sessionId);
      emit(EditFastingSessionLoaded(session));
    } catch (error) {
      emit(EditFastingSessionError(error.toString()));
    }
  }

  Future<void> _onUpdateFastingSessionTimes(
    UpdateFastingSessionTimes event,
    Emitter<EditFastingSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditFastingSessionLoaded) return;

    emit(EditFastingSessionUpdating(currentState.session));

    try {
      // Validate that start time is not in the future
      final now = DateTime.now();
      if (event.startTime != null && event.startTime!.isAfter(now)) {
        emit(EditFastingSessionError('Start time cannot be in the future'));
        return;
      }

      // Validate that end time is not in the future
      if (event.endTime != null && event.endTime!.isAfter(now)) {
        emit(EditFastingSessionError('End time cannot be in the future'));
        return;
      }

      // If both times are provided, validate that end is after start
      if (event.startTime != null &&
          event.endTime != null &&
          !event.endTime!.isAfter(event.startTime!)) {
        emit(EditFastingSessionError('End time must be after start time'));
        return;
      }

      // Get the current session to validate against
      final currentSession =
          await _fastingRepo.getFastingSessionById(currentState.session.id!);

      // Use provided times or keep existing ones
      final newStartTime = event.startTime ?? currentSession.start;
      final newEndTime = event.endTime ?? currentSession.end;

      // Final validation: end must be after start
      if (newEndTime != null && !newEndTime.isAfter(newStartTime)) {
        emit(EditFastingSessionError('End time must be after start time'));
        return;
      }

      // Update the session
      final updatedSession = await _fastingRepo.updateFastingSession(
        id: currentState.session.id!,
        start: event.startTime,
        end: event.endTime,
      );

      emit(EditFastingSessionLoaded(updatedSession));
    } catch (error) {
      emit(EditFastingSessionError(error.toString()));
    }
  }

  Future<void> _onDeleteFastingSession(
    DeleteFastingSession event,
    Emitter<EditFastingSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditFastingSessionLoaded) return;

    emit(const EditFastingSessionDeleting());

    try {
      await _fastingRepo.deleteFastingSession(currentState.session.id!);
      emit(const EditFastingSessionDeleted());
    } catch (error) {
      emit(EditFastingSessionError(error.toString()));
    }
  }
}
