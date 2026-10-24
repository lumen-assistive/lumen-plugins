import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:meta/meta.dart';

/// Immutable record produced when a [TranscriptSession] is closed.
@immutable
class TranscriptSessionSummary {
  /// Creates a session summary.
  const TranscriptSessionSummary({
    required this.startedAt,
    required this.endedAt,
    required this.text,
    required this.wordCount,
  });

  /// When the first final transcript segment was added.
  final DateTime startedAt;

  /// When the session was closed.
  final DateTime endedAt;

  /// The concatenation of every final transcript segment added, in
  /// order, separated by a single space.
  final String text;

  /// Number of whitespace-separated words in [text].
  final int wordCount;
}

/// Aggregates a sequence of final `TranscriptEvent`s into one session.
///
/// A new session should be created each time captioning starts (for
/// example when the user opens the live captions screen) and closed
/// when it stops, so that `lumen-app` can offer to save a readable
/// transcript of what was said during that period.
class TranscriptSession {
  final List<String> _segments = [];
  DateTime? _startedAt;
  bool _closed = false;

  /// Adds a final transcript segment to this session.
  ///
  /// Non-final segments (still being revised by the speech recognizer)
  /// are not meant to be passed here; filter for `isFinal` before
  /// calling this. Throws a [StateError] if the session is already
  /// closed.
  void addSegment(TranscriptEvent event) {
    if (_closed) {
      throw StateError('Cannot add a segment to a closed session.');
    }
    _startedAt ??= event.timestamp;
    final text = event.text.trim();
    if (text.isNotEmpty) {
      _segments.add(text);
    }
  }

  /// Closes the session and returns its summary.
  ///
  /// Throws a [StateError] if no segment was ever added, or if the
  /// session is already closed.
  TranscriptSessionSummary close({required DateTime endedAt}) {
    if (_closed) {
      throw StateError('Session is already closed.');
    }
    final startedAt = _startedAt;
    if (startedAt == null) {
      throw StateError('Cannot close a session with no segments.');
    }
    _closed = true;

    final text = _segments.join(' ');
    final wordCount = text.isEmpty
        ? 0
        : text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;

    return TranscriptSessionSummary(
      startedAt: startedAt,
      endedAt: endedAt,
      text: text,
      wordCount: wordCount,
    );
  }
}
