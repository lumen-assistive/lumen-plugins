/// How the user's day is going, as reported to caregivers.
enum DailyStatusValue {
  /// The user confirmed everything is fine today.
  ok,

  /// Something was flagged that a caregiver should look into.
  needsAttention,

  /// No status has been set for today yet.
  unknown,
}

/// A day's status, with the date it applies to.
class DailyStatus {
  /// Creates a daily status record.
  const DailyStatus({required this.date, required this.value});

  /// The calendar date this status applies to, with the time of day
  /// truncated away.
  final DateTime date;

  /// The status for [date].
  final DailyStatusValue value;
}
