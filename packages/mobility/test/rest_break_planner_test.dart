import 'package:lumen_plugin_mobility/lumen_plugin_mobility.dart';
import 'package:test/test.dart';

void main() {
  const planner = RestBreakPlanner();

  group('RestBreakPlanner', () {
    test('suggests no breaks for a walk shorter than one interval', () {
      final points = planner.breakPoints(
        totalDuration: const Duration(minutes: 10),
        verbosity: GuidanceVerbosity.standard,
      );
      expect(points, isEmpty);
    });

    test('suggests evenly spaced breaks at the standard interval', () {
      final points = planner.breakPoints(
        totalDuration: const Duration(minutes: 40),
        verbosity: GuidanceVerbosity.standard,
      );
      expect(points, [
        const Duration(minutes: 12),
        const Duration(minutes: 24),
        const Duration(minutes: 36),
      ]);
    });

    test('minimal verbosity suggests fewer, later breaks than detailed', () {
      const walkDuration = Duration(minutes: 40);
      final minimal = planner.breakPoints(
        totalDuration: walkDuration,
        verbosity: GuidanceVerbosity.minimal,
      );
      final detailed = planner.breakPoints(
        totalDuration: walkDuration,
        verbosity: GuidanceVerbosity.detailed,
      );
      expect(minimal.length, lessThan(detailed.length));
    });

    test('never suggests a break at or after the walk ends', () {
      final points = planner.breakPoints(
        totalDuration: const Duration(minutes: 40),
        verbosity: GuidanceVerbosity.detailed,
      );
      for (final point in points) {
        expect(point, lessThan(const Duration(minutes: 40)));
      }
    });
  });
}
