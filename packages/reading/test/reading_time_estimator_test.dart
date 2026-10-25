import 'package:lumen_plugin_reading/lumen_plugin_reading.dart';
import 'package:test/test.dart';

void main() {
  group('ReadingTimeEstimator', () {
    const estimator = ReadingTimeEstimator();

    test('estimates one minute for a short text', () {
      expect(estimator.estimateMinutes(50), 1);
    });

    test('estimates exactly one minute at the configured rate', () {
      expect(estimator.estimateMinutes(200), 1);
    });

    test('rounds up a partial minute', () {
      expect(estimator.estimateMinutes(201), 2);
    });

    test('returns zero for no words', () {
      expect(estimator.estimateMinutes(0), 0);
    });

    test('respects a custom reading speed', () {
      const slow = ReadingTimeEstimator(wordsPerMinute: 100);
      expect(slow.estimateMinutes(250), 3);
    });

    test('estimates from a block of text by counting its words', () {
      expect(estimator.estimateMinutesForText('one two three'), 1);
    });

    test('estimateMinutesForText returns zero for blank text', () {
      expect(estimator.estimateMinutesForText('   '), 0);
    });
  });
}
