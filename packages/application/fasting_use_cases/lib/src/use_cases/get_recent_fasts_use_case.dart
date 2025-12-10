import 'package:fasting_repository/fasting_repository.dart';

class GetRecentFastsUseCase {
  final FastingRepository _fastingRepository;

  GetRecentFastsUseCase({required FastingRepository fastingRepository})
    : _fastingRepository = fastingRepository;

  /// Gets the most recent completed fasting sessions.
  /// [limit] defaults to 3 if not specified.
  Future<List<FastingSession>> call({int limit = 3}) async {
    return await _fastingRepository.getFastingSessions(
      isActive: false,
      limit: limit,
    );
  }
}

