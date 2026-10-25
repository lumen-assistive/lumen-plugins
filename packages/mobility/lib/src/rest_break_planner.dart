import 'mobility_profile.dart';

/// Suggests rest break points for a planned walk, so a person pacing a
/// longer outing knows roughly when to expect a natural pause rather
/// than only finding out once they are already tired.
///
/// The break intervals below are a reasonable, documented starting
/// point, not a clinical mobility guideline: 20 minutes at
/// [GuidanceVerbosity.minimal] (a break only when most people would
/// already want one), 12 minutes at [GuidanceVerbosity.standard], and
/// 7 minutes at [GuidanceVerbosity.detailed] (frequent, reassuring
/// check-ins for someone who wants every cue spelled out).
class RestBreakPlanner {
  /// Creates a planner. Stateless: a single instance can be reused for
  /// any number of walks.
  const RestBreakPlanner();

  static const Map<GuidanceVerbosity, Duration> _intervalByVerbosity = {
    GuidanceVerbosity.minimal: Duration(minutes: 20),
    GuidanceVerbosity.standard: Duration(minutes: 12),
    GuidanceVerbosity.detailed: Duration(minutes: 7),
  };

  /// The suggested break points within a walk of [totalDuration], as
  /// offsets from the start, for the given [verbosity].
  ///
  /// The final suggested break is always strictly before
  /// [totalDuration]: a break point at or after the walk's own end
  /// would not be a break during the walk at all.
  List<Duration> breakPoints({
    required Duration totalDuration,
    required GuidanceVerbosity verbosity,
  }) {
    final interval = _intervalByVerbosity[verbosity]!;
    if (interval >= totalDuration) return const [];

    final points = <Duration>[];
    var next = interval;
    while (next < totalDuration) {
      points.add(next);
      next += interval;
    }
    return points;
  }
}
