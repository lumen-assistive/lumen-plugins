/// Wraps live transcript text into caption-sized lines.
///
/// Real captioning conventions (broadcast and web) keep each line short
/// enough to read in the time it is on screen, and never break a word
/// across two lines. This package has no rendering surface of its own;
/// `lumen-app` is expected to feed each line this returns into however
/// many caption rows its layout currently has room for.
class CaptionFormatter {
  /// Creates a formatter. Stateless: a single instance can be reused
  /// for any number of transcript chunks.
  const CaptionFormatter();

  /// Wraps [text] into lines of at most [maxCharactersPerLine]
  /// characters, breaking only between words.
  ///
  /// A single word longer than [maxCharactersPerLine] is kept whole on
  /// its own line rather than being cut mid-word, since a caption is
  /// meant to be read, not truncated unreadably.
  List<String> wrap(String text, {int maxCharactersPerLine = 32}) {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final lines = <String>[];
    var currentLine = StringBuffer();

    for (final word in words) {
      final candidateLength = currentLine.isEmpty
          ? word.length
          : currentLine.length + 1 + word.length;
      if (candidateLength > maxCharactersPerLine && currentLine.isNotEmpty) {
        lines.add(currentLine.toString());
        currentLine = StringBuffer();
      }
      if (currentLine.isNotEmpty) currentLine.write(' ');
      currentLine.write(word);
    }

    if (currentLine.isNotEmpty) lines.add(currentLine.toString());
    return lines;
  }
}
