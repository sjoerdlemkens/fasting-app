import 'package:test/test.dart';
import 'package:fasting_domain/fasting_domain.dart';
import 'package:local_fasting_api/local_fasting_api.dart' as api;
import 'package:fasting_repository/src/extensions/fasting_session_mappers.dart';

void main() {
  group('FastingSessionMappers', () {
    group('toDomain', () {
      test('maps api.FastingSession to domain FastingSession with all fields',
          () {
        final apiSession = api.FastingSession(
          id: 1,
          start: DateTime(2025, 3, 15, 12, 35),
          end: DateTime(2025, 3, 16, 6, 47, 5),
          window: 0, // sixteenEight
        );

        final domainSession = apiSession.toDomain();

        expect(domainSession.id, equals(1));
        expect(domainSession.start, equals(DateTime(2025, 3, 15, 12, 35)));
        expect(domainSession.end, equals(DateTime(2025, 3, 16, 6, 47, 5)));
        expect(domainSession.window, equals(FastingWindow.sixteenEight));
      });

      test(
          'maps api.FastingSession with null window to domain with null window',
          () {
        final apiSession = api.FastingSession(
          id: 2,
          start: DateTime(2025, 3, 15, 12, 35),
          end: null,
          window: null,
        );

        final domainSession = apiSession.toDomain();

        expect(domainSession.id, equals(2));
        expect(domainSession.start, equals(DateTime(2025, 3, 15, 12, 35)));
        expect(domainSession.end, isNull);
        expect(domainSession.window, isNull);
      });

      test('maps api.FastingSession with window 1 (eighteenSix)', () {
        final apiSession = api.FastingSession(
          id: 3,
          start: DateTime(2025, 3, 15, 12, 35),
          end: DateTime(2025, 3, 16, 6, 35),
          window: 1,
        );

        final domainSession = apiSession.toDomain();

        expect(domainSession.window, equals(FastingWindow.eighteenSix));
      });

      test('maps api.FastingSession with window 2 (omad)', () {
        final apiSession = api.FastingSession(
          id: 4,
          start: DateTime(2025, 3, 15, 12, 35),
          end: DateTime(2025, 3, 16, 12, 35),
          window: 2,
        );

        final domainSession = apiSession.toDomain();

        expect(domainSession.window, equals(FastingWindow.omad));
      });

      test('maps api.FastingSession with null end (active session)', () {
        final apiSession = api.FastingSession(
          id: 5,
          start: DateTime(2025, 3, 15, 12, 35),
          end: null,
          window: 1,
        );

        final domainSession = apiSession.toDomain();

        expect(domainSession.end, isNull);
      });

      test('preserves all field values correctly', () {
        final startTime = DateTime(2025, 3, 15, 12, 35);
        final endTime = DateTime(2025, 3, 16, 6, 47, 5);
        final apiSession = api.FastingSession(
          id: 6,
          start: startTime,
          end: endTime,
          window: 2,
        );

        final domainSession = apiSession.toDomain();

        expect(domainSession.id, equals(6));
        expect(domainSession.start, equals(startTime));
        expect(domainSession.end, equals(endTime));
        expect(domainSession.window, equals(FastingWindow.omad));
      });
    });
  });
}
