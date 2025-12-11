import 'package:fasting_domain/fasting_domain.dart';
import 'package:local_fasting_api/local_fasting_api.dart' as api;
import 'package:fasting_repository/src/extensions/extensions.dart';

extension FastingSessionMappers on api.FastingSession {
  FastingSession toDomain() => FastingSession(
        id: id,
        start: start,
        end: end,
        window: window == null ? null : FastingWindowMappers.fromInt(window!),
      );
}
