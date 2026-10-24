import 'package:meta/meta.dart';

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
  });

  /// Stable identifier, unique within a [CalendarStore].
  final String id;

  /// Short, human-readable title, for example a medical appointment.
  final String title;

  /// When the event starts.
  final DateTime start;

  /// When the event ends. Must not be before [start].
  final DateTime end;

  /// Optional free-text notes.
  final String? notes;
}
