import 'package:lumen_plugin_safety/lumen_plugin_safety.dart';
import 'package:test/test.dart';

void main() {
  group('CheckInScheduler', () {
    test('a user who never checked in is overdue', () {
      final scheduler = CheckInScheduler(now: () => DateTime(2026, 1, 1));
      expect(scheduler.isOverdue(const Duration(hours: 12)), isTrue);
      expect(scheduler.lastCheckInAt, isNull);
      expect(scheduler.timeUntilDue(const Duration(hours: 12)), isNull);
    });

    test('is not overdue right after checking in', () {
      var clock = DateTime(2026, 1, 1, 8);
      final scheduler = CheckInScheduler(now: () => clock);

      scheduler.checkIn();

      expect(scheduler.isOverdue(const Duration(hours: 12)), isFalse);
      expect(scheduler.lastCheckInAt, clock);
    });

    test('becomes overdue once the interval has elapsed', () {
      var clock = DateTime(2026, 1, 1, 8);
      final scheduler = CheckInScheduler(now: () => clock);

      scheduler.checkIn();
      clock = clock.add(const Duration(hours: 13));

      expect(scheduler.isOverdue(const Duration(hours: 12)), isTrue);
    });

    test('timeUntilDue counts down and goes negative once overdue', () {
      var clock = DateTime(2026, 1, 1, 8);
      final scheduler = CheckInScheduler(now: () => clock);

      scheduler.checkIn();
      clock = clock.add(const Duration(hours: 10));
      expect(
        scheduler.timeUntilDue(const Duration(hours: 12)),
        const Duration(hours: 2),
      );

      clock = clock.add(const Duration(hours: 5));
      expect(
        scheduler.timeUntilDue(const Duration(hours: 12))!.isNegative,
        isTrue,
      );
    });

    test('a second check-in resets the interval', () {
      var clock = DateTime(2026, 1, 1, 8);
      final scheduler = CheckInScheduler(now: () => clock);

      scheduler.checkIn();
      clock = clock.add(const Duration(hours: 11));
      scheduler.checkIn();
      clock = clock.add(const Duration(hours: 1));

      expect(scheduler.isOverdue(const Duration(hours: 12)), isFalse);
    });
  });
}
