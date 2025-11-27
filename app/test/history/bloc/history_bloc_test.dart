import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fasting_app/history/history.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

class MockGetMonthlyHistoryUseCase extends Mock implements GetMonthlyHistoryUseCase {}

void main() {
  group('HistoryBloc', () {
    late GetMonthlyHistoryUseCase mockGetMonthlyHistory;
    late HistoryBloc historyBloc;

    setUp(() {
      mockGetMonthlyHistory = MockGetMonthlyHistoryUseCase();
      historyBloc = HistoryBloc(getMonthlyHistory: mockGetMonthlyHistory);
    });

    tearDown(() {
      historyBloc.close();
    });

    test('initial state is HistoryInitial', () {
      expect(historyBloc.state, equals(const HistoryInitial()));
    });

    group('LoadHistoryMonth', () {
      final testMonth = DateTime(2025, 11, 15); // November 2025
      final mockSessionsByDay = {
        DateTime(2025, 11, 5): [
          FastingSession(
            id: 1,
            start: DateTime(2025, 11, 5, 8, 0),
            end: DateTime(2025, 11, 6, 0, 0),
            window: FastingWindow.sixteenEight,
          ),
        ],
        DateTime(2025, 11, 10): [
          FastingSession(
            id: 2,
            start: DateTime(2025, 11, 10, 18, 0),
            end: DateTime(2025, 11, 11, 12, 0),
            window: FastingWindow.eighteenSix,
          ),
        ],
      };

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] when LoadHistoryMonth succeeds',
        build: () {
          when(() => mockGetMonthlyHistory(any()))
              .thenAnswer((_) async => mockSessionsByDay);
          return historyBloc;
        },
        act: (bloc) => bloc.add(LoadHistoryMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryLoaded>()
              .having((state) => state.currentMonth, 'currentMonth', testMonth)
              .having(
                (state) => state.fastingSessionsByDay.length,
                'sessionsByDay length',
                2,
              ),
        ],
        verify: (_) {
          verify(() => mockGetMonthlyHistory(testMonth)).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryError] when LoadHistoryMonth fails',
        build: () {
          when(() => mockGetMonthlyHistory(any()))
              .thenThrow(Exception('Failed to load sessions'));
          return historyBloc;
        },
        act: (bloc) => bloc.add(LoadHistoryMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryError>().having((state) => state.message, 'error message',
              contains('Failed to load sessions')),
        ],
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] with empty sessions when no data',
        build: () {
          when(() => mockGetMonthlyHistory(any()))
              .thenAnswer((_) async => {});
          return historyBloc;
        },
        act: (bloc) => bloc.add(LoadHistoryMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryLoaded>()
              .having((state) => state.currentMonth, 'currentMonth', testMonth)
              .having(
                (state) => state.fastingSessionsByDay.isEmpty,
                'empty sessionsByDay',
                true,
              ),
        ],
      );
    });

    group('ChangeMonth', () {
      final testMonth = DateTime(2025, 12, 1);

      blocTest<HistoryBloc, HistoryState>(
        'triggers LoadHistoryMonth with new month',
        build: () {
          when(() => mockGetMonthlyHistory(any()))
              .thenAnswer((_) async => {});
          return historyBloc;
        },
        act: (bloc) => bloc.add(ChangeMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryLoaded>()
              .having((state) => state.currentMonth, 'currentMonth', testMonth),
        ],
        verify: (_) {
          verify(() => mockGetMonthlyHistory(testMonth)).called(1);
        },
      );
    });
  });
}
