import 'calendar_event.dart';

/// Persists and queries [CalendarEvent]s.
///
/// `lumen-plugin-famiglia` does not decide how events are stored;
/// `lumen-app` provides a real implementation backed by encrypted local
/// storage, and when caregiver sync is enabled, keeps it in sync with
/// `lumen-server`.
abstract class CalendarStore {
  /// Adds [event], replacing any existing event with the same id.
  Future<void> add(CalendarEvent event);

  /// Removes the event with [id]. Does nothing if it does not exist.
  Future<void> remove(String id);

  /// Lists every event whose [CalendarEvent.start] falls within
  /// `[from, to]` (inclusive), ordered by start time.
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
    final matches = _events.values
        .where(
          (event) => !event.start.isBefore(from) && !event.start.isAfter(to),
        )
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return matches;
  }
}
