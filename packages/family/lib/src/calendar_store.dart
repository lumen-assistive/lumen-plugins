import 'calendar_event.dart';

/// Persists and queries [CalendarEvent]s.
///
/// `lumen_plugin_family` does not decide how events are stored;
/// `lumen-app` provides a real implementation backed by encrypted local
/// storage, and when caregiver sync is enabled, keeps it in sync with
/// `lumen-server`.
abstract class CalendarStore {
  /// Adds [event], replacing any existing event with the same id.
  Future<void> add(CalendarEvent event);

  /// Removes the event with [id]. Does nothing if it does not exist.
  Future<void> remove(String id);

  /// Lists every occurrence whose start falls within `[from, to]`
  /// (inclusive), ordered by start time.
  ///
  /// A recurring event contributes one entry per occurrence that falls
  /// in range, each with [CalendarEvent.start]/[CalendarEvent.end] set
  /// to that specific occurrence rather than the event's original
  /// first occurrence, so a caller does not have to re-derive
  /// occurrence dates itself.
  Future<List<CalendarEvent>> listBetween(DateTime from, DateTime to);
}

/// In-memory [CalendarStore] for tests and examples.
class InMemoryCalendarStore implements CalendarStore {
  final Map<String, CalendarEvent> _events = {};

  @override
  Future<void> add(CalendarEvent event) async {
    _events[event.id] = event;
  }

  @override
  Future<void> remove(String id) async {
    _events.remove(id);
  }

  @override
  Future<List<CalendarEvent>> listBetween(DateTime from, DateTime to) async {
    final matches = <CalendarEvent>[];
    for (final event in _events.values) {
      matches.addAll(_occurrencesBetween(event, from, to));
    }
    matches.sort((a, b) => a.start.compareTo(b.start));
    return matches;
  }

  List<CalendarEvent> _occurrencesBetween(
    CalendarEvent event,
    DateTime from,
    DateTime to,
  ) {
    if (event.recurrence == CalendarRecurrence.none) {
      final inRange = !event.start.isBefore(from) && !event.start.isAfter(to);
      return inRange ? [event] : const [];
    }

    final step = switch (event.recurrence) {
      CalendarRecurrence.daily => const Duration(days: 1),
      CalendarRecurrence.weekly => const Duration(days: 7),
      CalendarRecurrence.none => Duration.zero,
    };

    final occurrences = <CalendarEvent>[];
    var occurrenceStart = event.start;
    while (!occurrenceStart.isAfter(to)) {
      if (!occurrenceStart.isBefore(from)) {
        occurrences.add(event.occurrenceAt(occurrenceStart));
      }
      occurrenceStart = occurrenceStart.add(step);
    }
    return occurrences;
  }
}
