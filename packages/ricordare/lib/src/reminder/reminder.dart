/// How a [Reminder] repeats after it is handled.
enum ReminderRecurrence {
  /// A one-time reminder.
  none,

  /// Repeats every day.
  daily,

  /// Repeats every week.
  weekly,
}

/// A reminder for something Lumen's user wants to be told about, for
/// example taking medication or an upcoming appointment.
class Reminder {
  /// Creates a reminder.
  Reminder({
    required this.id,
    required this.title,
    required this.dueAt,
    this.recurrence = ReminderRecurrence.none,
    this.completed = false,
  });

  /// Stable, unique identifier.
  final String id;

  /// What to remind the user about.
  final String title;

  /// When this reminder is next due.
  DateTime dueAt;

  /// Whether, and how often, this reminder repeats after being handled.
  final ReminderRecurrence recurrence;

  /// Whether a non-recurring reminder has already been handled. Always
  /// `false` for a recurring reminder, which is rescheduled instead of
  /// being marked complete; see [ReminderScheduler.markHandled].
  bool completed;
}
