import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:local_fasting_api/local_fasting_api.dart' as api;

class MockLocalFastingApi extends Mock implements api.LocalFastingApi {}

void main() {
  group('FastingRepository', () {
    late api.LocalFastingApi fastingApi;

    final apiFastingSessions = [
      api.FastingSession(
        id: 1,
        start:
            // March 15, 2025 at 12:35 PM
            DateTime(2025, 3, 15, 12, 35),
        end:
            // March 16, 2025 at 6:47:05 AM (18h 12m 5s after start)
            DateTime(2025, 3, 16, 6, 47, 5),
        window: 0,
      ),
    ];

    setUp(() {
      // Mock the fasting API
      fastingApi = MockLocalFastingApi();

      // Mock the api methods
      when(() => fastingApi.getFastingSessions()).thenAnswer(
        (_) async => apiFastingSessions,
      );

      // Create the subject
      FastingRepository createSubject() => FastingRepository(
            fastingApi: fastingApi,
          );

      group('constructor', () {
        test('works properly', () {
          expect(
            createSubject,
            returnsNormally,
          );
        });
      });

      group('getFastingSessions', () {
        test('makes correct api request', () {
          final subject = createSubject();

          // Expect that calling .getFastingSessions() does not throw an error
          expect(
            subject.getFastingSessions(),
            isNot(throwsA(anything)),
          );

          // Verify that the .getFastingSessions() method was called on the api
          verify(() => fastingApi.getFastingSessions()).called(1);
        });

        // This should also check the domain mapping
        // test('returns list of fasting sessions', () {
        //   expect(
        //     createSubject().getFastingSessions(),
        //     equals(apiFastingSessions),
        //   );
        // });
      });
    });
  });
}
