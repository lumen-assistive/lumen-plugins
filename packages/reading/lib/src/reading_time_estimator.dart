/// Estimates how long a piece of text takes to read, for study planning
/// (for example showing "about 4 minutes" before a reading session).
///
/// The default reading speed, 200 words per minute, is a commonly
/// cited average for an adult reading silently in their native
/// language; real speed varies widely by reader and text, which is why
/// it is a constructor parameter rather than a hidden constant.
class ReadingTimeEstimator {
  /// Creates an estimator. [wordsPerMinute] defaults to 200, a commonly
  /// cited average adult silent reading speed; pass a different value
  /// for a specific reader's known pace.
  const ReadingTimeEstimator({this.wordsPerMinute = 200})
      : assert(wordsPerMinute > 0, 'wordsPerMinute must be positive');

  /// The reading speed this estimator assumes.
  final int wordsPerMinute;

  /// Estimated reading time for [wordCount] words, rounded up to the
  /// next whole minute so a short text still reads as "about 1 minute"
  /// rather than "0 minutes".
  int estimateMinutes(int wordCount) {
    if (wordCount <= 0) return 0;
    return (wordCount / wordsPerMinute).ceil();
  }

  /// Estimated reading time for a block of [text], by counting its
  /// words and delegating to [estimateMinutes].
  int estimateMinutesForText(String text) {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return estimateMinutes(words.length);
  }
}
