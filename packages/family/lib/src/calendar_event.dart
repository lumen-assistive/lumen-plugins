import 'package:meta/meta.dart';

/// How a [CalendarEvent] repeats after its first occurrence.
///
/// The same shape as `lumen_plugin_memory`'s `ReminderRecurrence`,
/// defined separately here rather than shared across packages: a
/// calendar event and a reminder are different concepts that happen to
/// repeat the same way, and this package has no dependency on
/// `lumen_plugin_memory` to justify importing its enum.
enum CalendarRecurrence {
  /// A one-time event.
  none,

  /// Repeats every day.
  daily,

  /// Repeats every week.
  weekly,
}

/// An entry on the calendar shared between the user and their
/// caregivers.
@immutable
class CalendarEvent {
  /// Creates a calendar event.
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.notes,
    this.recurrence = CalendarRecurrence.none,
  });

  /// Stable identifier, unique within a [CalendarStore].
  final String id;

  /// Short, human-readable title, for example a medical appointment.
  final String title;

  /// When this occurrence starts. For a recurring event, this is the
  /// first occurrence; later ones are computed from it, not stored
  /// separately.
  final DateTime start;

  /// When this occurrence ends. Must not be before [start].
  final DateTime end;

  /// Optional free-text notes.
  final String? notes;

  /// Whether, and how often, this event repeats after [start].
  final CalendarRecurrence recurrence;

  /// This event shifted so a recurring occurrence starts at
  /// [occurrenceStart], keeping the original duration and every other
  /// field unchanged.
  CalendarEvent occurrenceAt(DateTime occurrenceStart) {
    final duration = end.difference(start);
    return CalendarEvent(
      id: id,
      title: title,
      start: occurrenceStart,
      end: occurrenceStart.add(duration),
      notes: notes,
      recurrence: recurrence,
    );
  }
}
