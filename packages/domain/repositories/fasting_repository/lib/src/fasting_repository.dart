import 'package:fasting_entities/fasting_entities.dart';
import 'package:local_fasting_api/local_fasting_api.dart';

class FastingRepository {
  final LocalFastingApi _fastingApi;

  const FastingRepository({
    required LocalFastingApi fastingApi,
  }) : _fastingApi = fastingApi;

  Future<FastingSession> createFastingSession({
    required DateTime started,
    required FastingWindow window,
  }) async {
    final createdFast = await _fastingApi.createFastingSession(
      started: started,
    );

//TODO: use extension method to map
    final mappedFast = FastingSession(
      id: createdFast.id,
      start: createdFast.start,
      window: window, // map fasting window appropriately
    );

    return mappedFast;
  }

  Future<FastingSession?> getActiveFastingSession() async {
    final activeFast = await _fastingApi.getActiveFastingSession();
    if (activeFast == null) {
      return null;
    }

    final mappedFast = FastingSession(
      id: activeFast.id,
      start: activeFast.start,
      window: FastingWindow.eighteenSix, // map fasting window appropriately
    );

    return mappedFast;
  }
}
