import 'package:fasting_api/fasting_api.dart' as api;
import 'package:fasting_repository/fasting_repository.dart';

extension FastingSessionMappers on api.FastingSession {
  FastingSession toDomain() => FastingSession(
        id: id,
        start: start,
        end: end,
        window: window == null ? null : FastingWindowMappers.fromInt(window!),
      );
}
