import 'package:fasting_repository/fasting_repository.dart';

class DeleteFastUseCase {
  final FastingRepository _fastingRepo;

  DeleteFastUseCase({required FastingRepository fastingRepo})
      : _fastingRepo = fastingRepo;

  Future<void> call(int fastId) async {
    await _fastingRepo.deleteFastingSession(fastId);
  }
}

