import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';
import 'package:meta/meta.dart';

part 'edit_fasting_session_event.dart';
part 'edit_fasting_session_state.dart';

class EditFastingSessionBloc
    extends Bloc<EditFastingSessionEvent, EditFastingSessionState> {
  final GetFastingSessionByIdUseCase _getFastingSessionById;
  final UpdateCompletedFastUseCase _updateCompletedFast;
  final DeleteFastUseCase _deleteFast;

  EditFastingSessionBloc({
    required GetFastingSessionByIdUseCase getFastingSessionById,
    required UpdateCompletedFastUseCase updateCompletedFast,
    required DeleteFastUseCase deleteFast,
  })  : _getFastingSessionById = getFastingSessionById,
        _updateCompletedFast = updateCompletedFast,
        _deleteFast = deleteFast,
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
      final session = await _getFastingSessionById(event.sessionId);
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
      final updatedSession = await _updateCompletedFast(
        fastId: currentState.session.id!,
        startTime: event.startTime,
        endTime: event.endTime,
      );

      if (updatedSession != null) {
        emit(EditFastingSessionLoaded(updatedSession));
      } else {
        emit(EditFastingSessionError('Failed to update session'));
      }
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
      await _deleteFast(currentState.session.id!);
      emit(const EditFastingSessionDeleted());
    } catch (error) {
      emit(EditFastingSessionError(error.toString()));
    }
  }
}

