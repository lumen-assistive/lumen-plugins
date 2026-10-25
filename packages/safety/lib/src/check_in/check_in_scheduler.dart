/// Tracks when the user last confirmed they are ok, and whether they
/// are now overdue for another check-in.
///
/// Distinct from `lumen_plugin_family`'s `DailyStatusTracker`, which
/// records a once-a-day status for caregivers to see: this is a
/// rolling interval, meant for a user who has opted into more frequent
/// safety check-ins (for example someone living alone), not tied to
/// calendar day boundaries.
class CheckInScheduler {
  /// Creates a scheduler. [now] defaults to [DateTime.now]; tests pass
  /// a fixed or steppable clock instead.
  CheckInScheduler({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  DateTime? _lastCheckInAt;

  /// Records a check-in at the current time.
  void checkIn() {
    _lastCheckInAt = _now();
  }

  /// When the last check-in happened, or `null` if none has happened
  /// yet.
  DateTime? get lastCheckInAt => _lastCheckInAt;

  /// Whether the user is overdue for a check-in, given [interval] since
  /// the last one. A user who has never checked in is always
  /// considered overdue, since there is nothing to measure the
  /// interval from.
  bool isOverdue(Duration interval) {
    final lastCheckInAt = _lastCheckInAt;
    if (lastCheckInAt == null) return true;
    return _now().difference(lastCheckInAt) > interval;
  }

  /// How long until the next check-in is due, given [interval] since
  /// the last one. Zero or negative once overdue. `null` if the user
  /// has never checked in, since there is no interval to count down
  /// from.
  Duration? timeUntilDue(Duration interval) {
    final lastCheckInAt = _lastCheckInAt;
    if (lastCheckInAt == null) return null;
    final due = lastCheckInAt.add(interval);
    return due.difference(_now());
  }
}
