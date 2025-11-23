import 'package:fasting_entities/fasting_entities.dart';
import 'package:local_fasting_api/local_fasting_api.dart' as api;
import 'package:fasting_repository/src/extensions/extensions.dart';

extension FastingSessionMappers on api.FastingSession {
  FastingSession toDomain() => FastingSession(
        id: id,
        start: start,
        end: end,
        window: FastingWindowMappers.fromInt(window), 
      );
}
