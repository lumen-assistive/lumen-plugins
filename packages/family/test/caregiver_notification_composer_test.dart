import 'package:lumen_plugin_family/lumen_plugin_family.dart';
import 'package:test/test.dart';

void main() {
  const composer = CaregiverNotificationComposer();

  group('CaregiverNotificationComposer', () {
    test('composes an all-ok status with no events', () {
      final text = composer.compose(
        status:
            DailyStatus(date: DateTime(2026, 2, 1), value: DailyStatusValue.ok),
        upcomingEvents: const [],
      );
      expect(text, 'Status: all ok. No upcoming events.');
    });

    test('composes a needs-attention status with one event', () {
      final text = composer.compose(
        status: DailyStatus(
          date: DateTime(2026, 2, 1),
          value: DailyStatusValue.needsAttention,
        ),
        upcomingEvents: [
          CalendarEvent(
            id: 'a',
            title: 'Doctor visit',
            start: DateTime(2026, 2, 1, 9),
            end: DateTime(2026, 2, 1, 10),
          ),
        ],
      );
      expect(
        text,
        'Status: needs attention. 1 upcoming event: Doctor visit.',
      );
    });

    test('lists multiple events with correct pluralization', () {
      final text = composer.compose(
        status: DailyStatus(
            date: DateTime(2026, 2, 1), value: DailyStatusValue.unknown),
        upcomingEvents: [
          CalendarEvent(
            id: 'a',
            title: 'Doctor visit',
            start: DateTime(2026, 2, 1, 9),
            end: DateTime(2026, 2, 1, 10),
          ),
          CalendarEvent(
            id: 'b',
            title: 'Physiotherapy',
            start: DateTime(2026, 2, 1, 15),
            end: DateTime(2026, 2, 1, 16),
          ),
        ],
      );
      expect(
        text,
        'Status: not set yet today. 2 upcoming events: Doctor visit, Physiotherapy.',
      );
    });
  });
}
