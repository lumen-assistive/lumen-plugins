import 'calendar_event.dart';
import 'daily_status.dart';

/// Composes a plain-text notification a caregiver can be shown,
/// summarizing a [DailyStatus] and the upcoming [CalendarEvent]s that
/// matter to them.
///
/// This package has no notification delivery mechanism of its own:
/// `lumen-server` and the caregiver's own client decide how (push,
/// SMS, in-app) and whether to actually deliver the text this builds.
class CaregiverNotificationComposer {
  /// Creates a composer. Stateless: a single instance can be reused for
  /// any number of status and event combinations.
  const CaregiverNotificationComposer();

  /// Composes a notification from [status] and [upcomingEvents].
  ///
  /// [upcomingEvents] should already be filtered to whatever window the
  /// caller considers "upcoming" (for example the next 24 hours); this
  /// method only formats what it is given, it does not decide the
  /// window itself.
  String compose({
    required DailyStatus status,
    required List<CalendarEvent> upcomingEvents,
  }) {
    final statusText = switch (status.value) {
      DailyStatusValue.ok => 'Status: all ok.',
      DailyStatusValue.needsAttention => 'Status: needs attention.',
      DailyStatusValue.unknown => 'Status: not set yet today.',
    };

    if (upcomingEvents.isEmpty) {
      return '$statusText No upcoming events.';
    }

    final eventList = upcomingEvents.map((event) => event.title).join(', ');
    final count = upcomingEvents.length;
    final eventWord = count == 1 ? 'event' : 'events';
    return '$statusText $count upcoming $eventWord: $eventList.';
  }
}
