import 'package:fasting_repository/fasting_repository.dart';

class GetFastingSessionByIdUseCase {
  final FastingRepository _fastingRepo;

  GetFastingSessionByIdUseCase({required FastingRepository fastingRepo})
      : _fastingRepo = fastingRepo;

  Future<FastingSession> call(int sessionId) async {
    return await _fastingRepo.getFastingSessionById(sessionId);
  }
}

