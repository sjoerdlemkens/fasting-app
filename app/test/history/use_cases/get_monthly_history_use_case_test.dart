import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';
import 'package:fasting_repository/fasting_repository.dart';

class MockFastingRepository extends Mock implements FastingRepository {}

void main() {
  group('GetMonthlyHistoryUseCase', () {
    late FastingRepository mockRepository;
    late GetMonthlyHistoryUseCase useCase;

    setUp(() {
      mockRepository = MockFastingRepository();
      useCase = GetMonthlyHistoryUseCase(fastingRepository: mockRepository);
    });

    group('call', () {
      final testMonth = DateTime(2025, 11, 15); // November 2025
      final firstDayOfMonth = DateTime(2025, 11, 1);
      final lastDayOfMonth = DateTime(2025, 11, 30);

      final mockSessions = [
        FastingSession(
          id: 1,
          start: DateTime(2025, 11, 5, 8, 0),
          end: DateTime(2025, 11, 6, 0, 0),
          window: FastingWindow.sixteenEight,
        ),
        FastingSession(
          id: 2,
          start: DateTime(2025, 11, 10, 18, 0),
          end: DateTime(2025, 11, 11, 12, 0),
          window: FastingWindow.eighteenSix,
        ),
        FastingSession(
          id: 3,
          start: DateTime(2025, 11, 15, 7, 0),
          end: DateTime(2025, 11, 16, 6, 0),
          window: FastingWindow.omad,
        ),
      ];

      test('returns sessions grouped by day', () async {
        // Arrange
        when(
          () => mockRepository.getFastingSessions(
            startAfter: any(named: 'startAfter'),
            startBefore: any(named: 'startBefore'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => mockSessions);

        // Act
        final result = await useCase(testMonth);

        // Assert
        expect(result, isA<Map<DateTime, List<FastingSession>>>());
        expect(result.length, equals(3));

        final nov5 = DateTime(2025, 11, 5);
        final nov10 = DateTime(2025, 11, 10);
        final nov15 = DateTime(2025, 11, 15);

        expect(result[nov5], hasLength(1));
        expect(result[nov10], hasLength(1));
        expect(result[nov15], hasLength(1));

        expect(result[nov5]!.first.id, equals(1));
        expect(result[nov10]!.first.id, equals(2));
        expect(result[nov15]!.first.id, equals(3));

        verify(
          () => mockRepository.getFastingSessions(
            startAfter: firstDayOfMonth.subtract(const Duration(days: 1)),
            startBefore: lastDayOfMonth.add(const Duration(days: 1)),
            isActive: false,
          ),
        ).called(1);
      });

      test('handles multiple sessions on the same day', () async {
        // Arrange
        final sessionsOnSameDay = [
          FastingSession(
            id: 1,
            start: DateTime(2025, 11, 5, 8, 0),
            end: DateTime(2025, 11, 6, 0, 0),
            window: FastingWindow.sixteenEight,
          ),
          FastingSession(
            id: 2,
            start: DateTime(2025, 11, 5, 20, 0),
            end: DateTime(2025, 11, 6, 14, 0),
            window: FastingWindow.eighteenSix,
          ),
        ];

        when(
          () => mockRepository.getFastingSessions(
            startAfter: any(named: 'startAfter'),
            startBefore: any(named: 'startBefore'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => sessionsOnSameDay);

        // Act
        final result = await useCase(testMonth);

        // Assert
        final nov5 = DateTime(2025, 11, 5);
        expect(result[nov5], hasLength(2));
        expect(result[nov5]!.map((s) => s.id), containsAll([1, 2]));
      });

      test('returns empty map when no sessions', () async {
        // Arrange
        when(
          () => mockRepository.getFastingSessions(
            startAfter: any(named: 'startAfter'),
            startBefore: any(named: 'startBefore'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => []);

        // Act
        final result = await useCase(testMonth);

        // Assert
        expect(result, isEmpty);
      });

      test('throws exception when repository fails', () async {
        // Arrange
        when(
          () => mockRepository.getFastingSessions(
            startAfter: any(named: 'startAfter'),
            startBefore: any(named: 'startBefore'),
            isActive: any(named: 'isActive'),
          ),
        ).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(
          () => useCase(testMonth),
          throwsA(isA<Exception>()),
        );
      });

      group('date calculations', () {
        test('handles February in leap year correctly', () async {
          // Arrange
          final februaryLeapYear = DateTime(2024, 2, 15); // 2024 is leap year
          when(
            () => mockRepository.getFastingSessions(
              startAfter: any(named: 'startAfter'),
              startBefore: any(named: 'startBefore'),
              isActive: any(named: 'isActive'),
            ),
          ).thenAnswer((_) async => []);

          // Act
          await useCase(februaryLeapYear);

          // Assert
          verify(
            () => mockRepository.getFastingSessions(
              startAfter: DateTime(2024, 1, 31), // Jan 31
              startBefore: DateTime(2024, 3, 1), // Mar 1 (Feb has 29 days in 2024)
              isActive: false,
            ),
          ).called(1);
        });

        test('handles December to January transition', () async {
          // Arrange
          final december = DateTime(2024, 12, 15);
          when(
            () => mockRepository.getFastingSessions(
              startAfter: any(named: 'startAfter'),
              startBefore: any(named: 'startBefore'),
              isActive: any(named: 'isActive'),
            ),
          ).thenAnswer((_) async => []);

          // Act
          await useCase(december);

          // Assert
          verify(
            () => mockRepository.getFastingSessions(
              startAfter: DateTime(2024, 11, 30), // Nov 30
              startBefore: DateTime(2025, 1, 1), // Jan 1 next year
              isActive: false,
            ),
          ).called(1);
        });
      });
    });
  });
}