import 'phrase.dart';

/// Joins a sequence of selected [Phrase]s into one composed sentence,
/// the step between tapping individual board entries and having
/// something to show or, once text-to-speech exists, speak.
///
/// This package has no text-to-speech output of its own; see the
/// package README for what that would require.
class SentenceBuilder {
  /// Creates a builder. Stateless: a single instance can be reused for
  /// any number of phrase sequences.
  const SentenceBuilder();

  /// Composes [phrases], in the order given, into one sentence in the
  /// given [locale].
  ///
  /// The first word is capitalized, phrases are joined with single
  /// spaces, and a trailing period is added only if the last phrase
  /// does not already end in sentence punctuation. Returns an empty
  /// string for an empty [phrases] list.
  String compose(List<Phrase> phrases,
      {SentenceLocale locale = SentenceLocale.en}) {
    if (phrases.isEmpty) return '';

    final words = [
      for (final phrase in phrases)
        locale == SentenceLocale.it ? phrase.textIt : phrase.textEn,
    ];

    final joined = words.join(' ');
    final capitalized = joined[0].toUpperCase() + joined.substring(1);

    const sentenceEndings = ['.', '!', '?'];
    final needsPeriod = !sentenceEndings.any(capitalized.endsWith);
    return needsPeriod ? '$capitalized.' : capitalized;
  }
}

/// Which of a [Phrase]'s two text fields [SentenceBuilder] should use.
enum SentenceLocale {
  /// Italian, the app's primary locale.
  it,

  /// English, the app's fallback locale.
  en,
}
