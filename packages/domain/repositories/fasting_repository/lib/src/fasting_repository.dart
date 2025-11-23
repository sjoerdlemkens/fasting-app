import 'package:fasting_repository/fasting_repository.dart';
import 'package:local_fasting_api/local_fasting_api.dart' hide FastingSession;

class FastingRepository {
  final LocalFastingApi _fastingApi;

  const FastingRepository({
    required LocalFastingApi fastingApi,
  }) : _fastingApi = fastingApi;

  Future<FastingSession> createFastingSession({
    required FastingWindow window,
    required DateTime started,
  }) async {
    final createdFast = await _fastingApi.createFastingSession(
      window: window.toInt(),
      started: started,
    );

    final mappedFast = createdFast.toDomain();

    return mappedFast;
  }

  Future<FastingSession?> getActiveFastingSession() async {
    final activeFast = await _fastingApi.getActiveFastingSession();
    if (activeFast == null) return null;

    final mappedFast = activeFast.toDomain();

    return mappedFast;
  }
}
