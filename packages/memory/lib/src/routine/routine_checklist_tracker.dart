DateTime _dateOnly(DateTime time) => DateTime(time.year, time.month, time.day);

/// Tracks a repeatable daily checklist of named steps (for example
/// "take morning medication", "lock the door"), resetting which steps
/// are marked done whenever the calendar day changes.
///
/// Mirrors `DailyStatusTracker`'s day-rollover pattern from
/// `lumen_plugin_family`: this package defines its own copy rather than
/// depending on that package for one small piece of shared behavior.
class RoutineChecklistTracker {
  /// Creates a tracker over the fixed list of [steps], identified by
  /// name. [now] defaults to [DateTime.now]; tests pass a fixed or
  /// steppable clock instead.
  RoutineChecklistTracker({
    required this.steps,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// Every step in this routine, in display order.
  final List<String> steps;

  final DateTime Function() _now;
  DateTime? _trackedDay;
  final Set<String> _completedToday = {};

  void _rolloverIfNewDay() {
    final today = _dateOnly(_now());
    if (_trackedDay != today) {
      _trackedDay = today;
      _completedToday.clear();
    }
  }

  /// Marks [step] as done for today. Does nothing if [step] is not in
  /// [steps].
  void markDone(String step) {
    if (!steps.contains(step)) return;
    _rolloverIfNewDay();
    _completedToday.add(step);
  }

  /// Marks [step] as not done for today, reversing [markDone].
  void markNotDone(String step) {
    _rolloverIfNewDay();
    _completedToday.remove(step);
  }

  /// Whether [step] has been marked done today. Always false for a
  /// step not in [steps].
  bool isDoneToday(String step) {
    _rolloverIfNewDay();
    return _completedToday.contains(step);
  }

  /// The steps not yet marked done today, in [steps] order.
  List<String> remainingToday() {
    _rolloverIfNewDay();
    return steps.where((step) => !_completedToday.contains(step)).toList();
  }

  /// Whether every step in [steps] has been marked done today.
  bool isFullyCompleteToday() {
    _rolloverIfNewDay();
    return _completedToday.length == steps.length;
  }
}
