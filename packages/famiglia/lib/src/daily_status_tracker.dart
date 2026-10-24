import 'daily_status.dart';

DateTime _dateOnly(DateTime time) => DateTime(time.year, time.month, time.day);

/// Tracks the "all ok today" status, resetting to [DailyStatusValue.unknown]
/// whenever the calendar day changes.
///
/// Takes a `now` provider rather than reading the system clock directly,
/// so tests can simulate a day rollover without waiting in real time.
class DailyStatusTracker {
  /// Creates a tracker. [now] defaults to [DateTime.now].
  DailyStatusTracker({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  DailyStatus? _current;

  /// Sets today's status to [value].
  ///
  /// If the stored status is for an earlier day, it is discarded first,
  /// so this always ends up applying to the current day.
  void setToday(DailyStatusValue value) {
    final today = _dateOnly(_now());
    _current = DailyStatus(date: today, value: value);
  }

  /// Returns today's status, or [DailyStatusValue.unknown] if none has
  /// been set yet today (including when a previous day's status has
  /// rolled over).
  DailyStatusValue statusForToday() {
    final today = _dateOnly(_now());
    final current = _current;
    if (current == null || current.date != today) {
      return DailyStatusValue.unknown;
    }
    return current.value;
  }
}
