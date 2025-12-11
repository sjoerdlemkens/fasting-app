import 'package:test/test.dart';
import 'package:fasting_domain/fasting_domain.dart';
import 'package:fasting_repository/src/extensions/fasting_window_mappers.dart';

void main() {
  group('FastingWindowMappers', () {
    group('toInt', () {
      test(
        'converts sixteenEight to 0',
        () => expect(
          FastingWindow.sixteenEight.toInt(),
          equals(0),
        ),
      );

      test(
        'converts eighteenSix to 1',
        () => expect(
          FastingWindow.eighteenSix.toInt(),
          equals(1),
        ),
      );

      test(
        'converts omad to 2',
        () => expect(
          FastingWindow.omad.toInt(),
          equals(2),
        ),
      );
    });

    group('fromInt', () {
      test(
        'converts 0 to sixteenEight',
        () => expect(
          FastingWindowMappers.fromInt(0),
          equals(FastingWindow.sixteenEight),
        ),
      );

      test(
        'converts 1 to eighteenSix',
        () => expect(
          FastingWindowMappers.fromInt(1),
          equals(FastingWindow.eighteenSix),
        ),
      );

      test(
        'converts 2 to omad',
        () => expect(
          FastingWindowMappers.fromInt(2),
          equals(FastingWindow.omad),
        ),
      );

      test(
        'throws ArgumentError for invalid value -1',
        () => expect(
          () => FastingWindowMappers.fromInt(-1),
          throwsA(isA<ArgumentError>()),
        ),
      );

      test(
        'throws ArgumentError for invalid value 3',
        () => expect(
          () => FastingWindowMappers.fromInt(3),
          throwsA(isA<ArgumentError>()),
        ),
      );

      test(
        'throws ArgumentError with correct message for invalid value',
        () => expect(
          () => FastingWindowMappers.fromInt(99),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Invalid FastingWindow value: 99'),
            ),
          ),
        ),
      );
    });
  });
}
