import 'package:lumen_plugin_hearing/lumen_plugin_hearing.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('TranscriptSession', () {
    test('aggregates segments into one summary', () {
      final session = TranscriptSession();

      session.addSegment(
        TranscriptEvent(
            timestamp: DateTime(2026, 1, 1, 10), text: 'Ciao', isFinal: true),
      );
      session.addSegment(
        TranscriptEvent(
            timestamp: DateTime(2026, 1, 1, 10, 0, 5),
            text: 'come va?',
            isFinal: true),
      );

      final summary = session.close(endedAt: DateTime(2026, 1, 1, 10, 1));

      expect(summary.startedAt, DateTime(2026, 1, 1, 10));
      expect(summary.endedAt, DateTime(2026, 1, 1, 10, 1));
      expect(summary.text, 'Ciao come va?');
      expect(summary.wordCount, 3);
    });

    test('ignores blank segments', () {
      final session = TranscriptSession();

      session.addSegment(
        TranscriptEvent(timestamp: DateTime(2026), text: '   ', isFinal: true),
      );
      session.addSegment(
        TranscriptEvent(
            timestamp: DateTime(2026), text: 'Pronto', isFinal: true),
      );

      final summary = session.close(endedAt: DateTime(2026));
      expect(summary.text, 'Pronto');
      expect(summary.wordCount, 1);
    });

    test('throws when closed with no segments', () {
      final session = TranscriptSession();
      expect(() => session.close(endedAt: DateTime(2026)), throwsStateError);
    });

    test('throws when adding a segment after close', () {
      final session = TranscriptSession();
      session.addSegment(
        TranscriptEvent(timestamp: DateTime(2026), text: 'Ciao', isFinal: true),
      );
      session.close(endedAt: DateTime(2026));

      expect(
        () => session.addSegment(
          TranscriptEvent(
              timestamp: DateTime(2026), text: 'Ancora', isFinal: true),
        ),
        throwsStateError,
      );
    });

    test('throws when closed twice', () {
      final session = TranscriptSession();
      session.addSegment(
        TranscriptEvent(timestamp: DateTime(2026), text: 'Ciao', isFinal: true),
      );
      session.close(endedAt: DateTime(2026));

      expect(() => session.close(endedAt: DateTime(2026)), throwsStateError);
    });
  });
}
