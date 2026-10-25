import 'reminder.dart';

/// Tracks [Reminder]s and which of them are currently due.
///
/// Takes a `now` provider rather than reading the system clock
/// directly, the same pattern `DailyStatusTracker` in
/// `lumen_plugin_family. uses, so tests can control what counts as
/// "due" without waiting in real time.
class ReminderScheduler {
  /// Creates a scheduler. [now] defaults to [DateTime.now].
  ReminderScheduler({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Map<String, Reminder> _reminders = {};

  /// Adds [reminder], or replaces the existing reminder with the same
  /// [Reminder.id] if there is one.
  void add(Reminder reminder) {
    _reminders[reminder.id] = reminder;
  }

  /// Every reminder being tracked.
  List<Reminder> all() => _reminders.values.toList(growable: false);

  /// Reminders that are due now and have not yet been handled.
  List<Reminder> dueReminders() {
    final now = _now();
    return _reminders.values
        .where(
            (reminder) => !reminder.completed && !reminder.dueAt.isAfter(now))
        .toList(growable: false);
  }

  /// Marks the reminder with [id] as handled.
  ///
  /// A one-time reminder is marked [Reminder.completed]. A recurring
  /// reminder is instead rescheduled to its next occurrence, so, for
  /// example, a daily medication reminder reappears automatically
  /// rather than needing to be recreated. Does nothing if no reminder
  /// has [id].
  void markHandled(String id) {
    final reminder = _reminders[id];
    if (reminder == null) return;

    switch (reminder.recurrence) {
      case ReminderRecurrence.none:
        reminder.completed = true;
      case ReminderRecurrence.daily:
        reminder.dueAt = reminder.dueAt.add(const Duration(days: 1));
      case ReminderRecurrence.weekly:
        reminder.dueAt = reminder.dueAt.add(const Duration(days: 7));
    }
  }

  /// Pushes the reminder with [id] [by] further into the future,
  /// without otherwise affecting its recurrence or completion state.
  ///
  /// Distinct from [markHandled]: snoozing means "not yet, ask me
  /// again later", while [markHandled] means "done", so a recurring
  /// reminder's next occurrence is unaffected by a snooze of the
  /// current one. Does nothing if no reminder has [id].
  void snooze(String id, Duration by) {
    final reminder = _reminders[id];
    if (reminder == null) return;
    reminder.dueAt = reminder.dueAt.add(by);
  }
}
