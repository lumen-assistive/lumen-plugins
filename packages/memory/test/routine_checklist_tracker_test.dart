import 'package:lumen_plugin_memory/lumen_plugin_memory.dart';
import 'package:test/test.dart';

void main() {
  group('RoutineChecklistTracker', () {
    test('nothing is done yet right after creation', () {
      final tracker = RoutineChecklistTracker(
        steps: const ['Take medication', 'Lock the door'],
        now: () => DateTime(2026, 1, 1, 8),
      );

      expect(tracker.remainingToday(), ['Take medication', 'Lock the door']);
      expect(tracker.isFullyCompleteToday(), isFalse);
    });

    test('marking a step done removes it from the remaining list', () {
      final tracker = RoutineChecklistTracker(
        steps: const ['Take medication', 'Lock the door'],
        now: () => DateTime(2026, 1, 1, 8),
      );

      tracker.markDone('Take medication');

      expect(tracker.isDoneToday('Take medication'), isTrue);
      expect(tracker.remainingToday(), ['Lock the door']);
      expect(tracker.isFullyCompleteToday(), isFalse);
    });

    test('completing every step reports the routine as fully done', () {
      final tracker = RoutineChecklistTracker(
        steps: const ['Take medication', 'Lock the door'],
        now: () => DateTime(2026, 1, 1, 8),
      );

      tracker.markDone('Take medication');
      tracker.markDone('Lock the door');

      expect(tracker.isFullyCompleteToday(), isTrue);
      expect(tracker.remainingToday(), isEmpty);
    });

    test('markDone ignores a step that is not part of the routine', () {
      final tracker = RoutineChecklistTracker(
        steps: const ['Take medication'],
        now: () => DateTime(2026, 1, 1, 8),
      );

      tracker.markDone('Not a real step');

      expect(tracker.isDoneToday('Not a real step'), isFalse);
      expect(tracker.remainingToday(), ['Take medication']);
    });

    test('markNotDone reverses a completion', () {
      final tracker = RoutineChecklistTracker(
        steps: const ['Take medication'],
        now: () => DateTime(2026, 1, 1, 8),
      );

      tracker.markDone('Take medication');
      tracker.markNotDone('Take medication');

      expect(tracker.isDoneToday('Take medication'), isFalse);
    });

    test('resets completion when the calendar day changes', () {
      var clock = DateTime(2026, 1, 1, 22);
      final tracker = RoutineChecklistTracker(
        steps: const ['Take medication'],
        now: () => clock,
      );

      tracker.markDone('Take medication');
      expect(tracker.isDoneToday('Take medication'), isTrue);

      clock = DateTime(2026, 1, 2, 7);
      expect(tracker.isDoneToday('Take medication'), isFalse);
      expect(tracker.remainingToday(), ['Take medication']);
    });
  });
}
