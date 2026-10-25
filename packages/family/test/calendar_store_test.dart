import 'package:lumen_plugin_family/lumen_plugin_family.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryCalendarStore', () {
    late InMemoryCalendarStore store;

    setUp(() {
      store = InMemoryCalendarStore();
    });

    test('lists events within range ordered by start time', () async {
      final earlier = CalendarEvent(
        id: 'a',
        title: 'Visita medica',
        start: DateTime(2026, 2, 1, 9),
        end: DateTime(2026, 2, 1, 10),
      );
      final later = CalendarEvent(
        id: 'b',
        title: 'Fisioterapia',
        start: DateTime(2026, 2, 1, 15),
        end: DateTime(2026, 2, 1, 16),
      );
      final outOfRange = CalendarEvent(
        id: 'c',
        title: 'Fuori intervallo',
        start: DateTime(2026, 3, 1),
        end: DateTime(2026, 3, 1, 1),
      );

      await store.add(later);
      await store.add(earlier);
      await store.add(outOfRange);

      final results = await store.listBetween(
        DateTime(2026, 2, 1),
        DateTime(2026, 2, 2),
      );

      expect(results, [earlier, later]);
    });

    test('remove deletes an event by id', () async {
      final event = CalendarEvent(
        id: 'a',
        title: 'Visita medica',
        start: DateTime(2026, 2, 1),
        end: DateTime(2026, 2, 1, 1),
      );
      await store.add(event);

      await store.remove('a');

      final results = await store.listBetween(
        DateTime(2026, 1, 1),
        DateTime(2026, 3, 1),
      );
      expect(results, isEmpty);
    });

    test('adding an event with an existing id replaces it', () async {
      final original = CalendarEvent(
        id: 'a',
        title: 'Originale',
        start: DateTime(2026, 2, 1),
        end: DateTime(2026, 2, 1, 1),
      );
      final replacement = CalendarEvent(
        id: 'a',
        title: 'Sostituito',
        start: DateTime(2026, 2, 1),
        end: DateTime(2026, 2, 1, 1),
      );

      await store.add(original);
      await store.add(replacement);

      final results = await store.listBetween(
        DateTime(2026, 1, 1),
        DateTime(2026, 3, 1),
      );
      expect(results, [replacement]);
    });

    test('a daily recurring event contributes one occurrence per day in range',
        () async {
      final event = CalendarEvent(
        id: 'meds',
        title: 'Medicine',
        start: DateTime(2026, 2, 1, 8),
        end: DateTime(2026, 2, 1, 8, 15),
        recurrence: CalendarRecurrence.daily,
      );
      await store.add(event);

      final results = await store.listBetween(
        DateTime(2026, 2, 1),
        DateTime(2026, 2, 3, 23, 59),
      );

      expect(results.length, 3);
      expect(results.map((e) => e.start), [
        DateTime(2026, 2, 1, 8),
        DateTime(2026, 2, 2, 8),
        DateTime(2026, 2, 3, 8),
      ]);
      // Duration is preserved on every occurrence.
      for (final occurrence in results) {
        expect(occurrence.end.difference(occurrence.start),
            const Duration(minutes: 15));
      }
    });

    test('a weekly recurring event steps by seven days', () async {
      final event = CalendarEvent(
        id: 'therapy',
        title: 'Physiotherapy',
        start: DateTime(2026, 2, 1, 10),
        end: DateTime(2026, 2, 1, 11),
        recurrence: CalendarRecurrence.weekly,
      );
      await store.add(event);

      final results = await store.listBetween(
        DateTime(2026, 2, 1),
        DateTime(2026, 2, 20),
      );

      expect(results.map((e) => e.start), [
        DateTime(2026, 2, 1, 10),
        DateTime(2026, 2, 8, 10),
        DateTime(2026, 2, 15, 10),
      ]);
    });

    test(
        'a recurring event before the query range still contributes future occurrences',
        () async {
      final event = CalendarEvent(
        id: 'meds',
        title: 'Medicine',
        start: DateTime(2026, 1, 1, 8),
        end: DateTime(2026, 1, 1, 8, 15),
        recurrence: CalendarRecurrence.daily,
      );
      await store.add(event);

      final results = await store.listBetween(
        DateTime(2026, 2, 1),
        DateTime(2026, 2, 1, 23, 59),
      );

      expect(results.length, 1);
      expect(results.single.start, DateTime(2026, 2, 1, 8));
    });
  });
}
