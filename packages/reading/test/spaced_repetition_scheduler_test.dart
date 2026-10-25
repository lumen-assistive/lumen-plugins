import 'package:lumen_plugin_reading/lumen_plugin_reading.dart';
import 'package:test/test.dart';

void main() {
  group('SpacedRepetitionScheduler', () {
    const scheduler = SpacedRepetitionScheduler();

    test('first successful review schedules a 1-day interval', () {
      final outcome = scheduler.review(
        quality: 5,
        previousRepetitionCount: 0,
        previousIntervalDays: 0,
        previousEasinessFactor: 2.5,
      );

      expect(outcome.repetitionCount, 1);
      expect(outcome.intervalDays, 1);
      expect(outcome.easinessFactor, closeTo(2.6, 1e-9));
    });

    test('second successful review schedules a 6-day interval', () {
      final outcome = scheduler.review(
        quality: 5,
        previousRepetitionCount: 1,
        previousIntervalDays: 1,
        previousEasinessFactor: 2.6,
      );

      expect(outcome.repetitionCount, 2);
      expect(outcome.intervalDays, 6);
      expect(outcome.easinessFactor, closeTo(2.7, 1e-9));
    });

    test(
        'third successful review multiplies the interval by the easiness factor',
        () {
      final outcome = scheduler.review(
        quality: 5,
        previousRepetitionCount: 2,
        previousIntervalDays: 6,
        previousEasinessFactor: 2.7,
      );

      expect(outcome.repetitionCount, 3);
      expect(outcome.intervalDays, 16); // round(6 * 2.7) = round(16.2)
      expect(outcome.easinessFactor, closeTo(2.8, 1e-9));
    });

    test('a quality below 3 resets the repetition count and interval', () {
      final outcome = scheduler.review(
        quality: 1,
        previousRepetitionCount: 4,
        previousIntervalDays: 20,
        previousEasinessFactor: 2.3,
      );

      expect(outcome.repetitionCount, 0);
      expect(outcome.intervalDays, 1);
    });

    test('a low quality lowers the easiness factor', () {
      final outcome = scheduler.review(
        quality: 2,
        previousRepetitionCount: 1,
        previousIntervalDays: 1,
        previousEasinessFactor: 2.5,
      );

      // qualityDeficit = 3; delta = 0.1 - 3 * (0.08 + 3 * 0.02) = -0.32.
      expect(outcome.easinessFactor, closeTo(2.18, 1e-9));
    });

    test('the easiness factor never drops below 1.3', () {
      var factor = 1.4;
      for (var i = 0; i < 10; i++) {
        final outcome = scheduler.review(
          quality: 0,
          previousRepetitionCount: 0,
          previousIntervalDays: 1,
          previousEasinessFactor: factor,
        );
        factor = outcome.easinessFactor;
      }

      expect(factor, 1.3);
    });
  });
}
