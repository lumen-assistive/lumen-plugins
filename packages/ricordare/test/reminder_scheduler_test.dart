import 'package:lumen_plugin_ricordare/lumen_plugin_ricordare.dart';
import 'package:test/test.dart';

void main() {
  group('ReminderScheduler', () {
    test('a reminder due in the past is reported as due', () {
      final scheduler = ReminderScheduler(now: () => DateTime(2026, 1, 2));
      scheduler.add(Reminder(
          id: 'r1', title: 'Take medication', dueAt: DateTime(2026, 1, 1)));

      expect(scheduler.dueReminders().map((r) => r.id), ['r1']);
    });

    test('a reminder due in the future is not reported', () {
      final scheduler = ReminderScheduler(now: () => DateTime(2026, 1, 1));
      scheduler.add(Reminder(
          id: 'r1', title: 'Take medication', dueAt: DateTime(2026, 1, 2)));

      expect(scheduler.dueReminders(), isEmpty);
    });

    test('markHandled completes a one-time reminder', () {
      final scheduler = ReminderScheduler(now: () => DateTime(2026, 1, 1));
      scheduler.add(
          Reminder(id: 'r1', title: 'Dentist', dueAt: DateTime(2026, 1, 1)));

      scheduler.markHandled('r1');

      expect(scheduler.dueReminders(), isEmpty);
      expect(scheduler.all().single.completed, isTrue);
    });

    test('markHandled reschedules a daily reminder instead of completing it',
        () {
      final scheduler = ReminderScheduler(now: () => DateTime(2026, 1, 1));
      scheduler.add(
        Reminder(
          id: 'r1',
          title: 'Take medication',
          dueAt: DateTime(2026, 1, 1),
          recurrence: ReminderRecurrence.daily,
        ),
      );

      scheduler.markHandled('r1');

      final reminder = scheduler.all().single;
      expect(reminder.completed, isFalse);
      expect(reminder.dueAt, DateTime(2026, 1, 2));
    });

    test('markHandled reschedules a weekly reminder seven days out', () {
      final scheduler = ReminderScheduler(now: () => DateTime(2026, 1, 1));
      scheduler.add(
        Reminder(
          id: 'r1',
          title: 'Weekly check-in',
          dueAt: DateTime(2026, 1, 1),
          recurrence: ReminderRecurrence.weekly,
        ),
      );

      scheduler.markHandled('r1');

      expect(scheduler.all().single.dueAt, DateTime(2026, 1, 8));
    });

    test('markHandled does nothing for an unknown id', () {
      final scheduler = ReminderScheduler(now: () => DateTime(2026, 1, 1));

      expect(() => scheduler.markHandled('missing'), returnsNormally);
    });
  });
}
