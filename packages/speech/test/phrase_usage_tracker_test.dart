import 'package:lumen_plugin_speech/lumen_plugin_speech.dart';
import 'package:test/test.dart';

void main() {
  group('PhraseUsageTracker', () {
    test('returns no suggestions before any phrase is used', () {
      final tracker = PhraseUsageTracker(now: () => DateTime(2026, 1, 1));

      expect(tracker.topSuggestions(), isEmpty);
    });

    test('ranks a more frequently used phrase first when recency is equal', () {
      final tracker = PhraseUsageTracker(now: () => DateTime(2026, 1, 1));

      tracker.recordUse('water');
      tracker.recordUse('hello');
      tracker.recordUse('hello');
      tracker.recordUse('hello');

      expect(tracker.topSuggestions(limit: 2), ['hello', 'water']);
    });

    test('a recent single use can outrank an older, more frequent one', () {
      var now = DateTime(2026, 1, 1);
      final tracker = PhraseUsageTracker(now: () => now);

      for (var i = 0; i < 5; i++) {
        tracker.recordUse('water');
      }

      // Three half-lives at the default 24-hour half-life: water's score
      // decays from 5 to 5 * 0.5^3 = 0.625, below hello's fresh score of 1.
      now = now.add(const Duration(hours: 72));
      tracker.recordUse('hello');

      expect(tracker.topSuggestions().first, 'hello');
    });

    test('limits the result to the requested count', () {
      final tracker = PhraseUsageTracker(now: () => DateTime(2026, 1, 1));

      tracker.recordUse('a');
      tracker.recordUse('b');
      tracker.recordUse('c');

      expect(tracker.topSuggestions(limit: 2), hasLength(2));
    });
  });

  group('PhraseUsageTracker.mostUsedOverall', () {
    test('returns no phrases before any are used', () {
      final tracker = PhraseUsageTracker(now: () => DateTime(2026, 1, 1));
      expect(tracker.mostUsedOverall(), isEmpty);
    });

    test('ranks by total count, ignoring how long ago that was', () {
      var now = DateTime(2026, 1, 1);
      final tracker = PhraseUsageTracker(now: () => now);

      for (var i = 0; i < 5; i++) {
        tracker.recordUse('water');
      }
      now = now.add(const Duration(days: 30));
      tracker.recordUse('hello');

      // topSuggestions would favor the recent "hello"; mostUsedOverall
      // should not, since water's five uses outnumber hello's one.
      expect(tracker.mostUsedOverall().first, 'water');
    });

    test('breaks a tie in count by whichever was used more recently', () {
      var now = DateTime(2026, 1, 1);
      final tracker = PhraseUsageTracker(now: () => now);

      tracker.recordUse('water');
      now = now.add(const Duration(hours: 1));
      tracker.recordUse('bathroom');

      expect(tracker.mostUsedOverall(limit: 2), ['bathroom', 'water']);
    });

    test('limits the result to the requested count', () {
      final tracker = PhraseUsageTracker(now: () => DateTime(2026, 1, 1));
      tracker.recordUse('a');
      tracker.recordUse('b');
      tracker.recordUse('c');

      expect(tracker.mostUsedOverall(limit: 2), hasLength(2));
    });
  });
}
