/// Picks the most representative sentences out of a transcript.
///
/// This is a plain word-frequency extractive heuristic, the same kind
/// of technique used in classic text-summarization exercises: common
/// "stop words" are ignored, every remaining word is scored by how
/// often it recurs in the text, and each sentence's score is the sum of
/// its words' scores. It is not a machine-learned summarizer and makes
/// no claim to understand the text; it exists as a placeholder so
/// `lumen-app` has something useful to show today, until an on-device
/// summarization model is integrated through `lumen-core`.
class Summarizer {
  /// Words excluded from scoring because they carry little topical
  /// weight in Italian running speech.
  static const _stopWords = {
    'il',
    'lo',
    'la',
    'i',
    'gli',
    'le',
    'un',
    'uno',
    'una',
    'di',
    'a',
    'da',
    'in',
    'con',
    'su',
    'per',
    'tra',
    'fra',
    'e',
    'o',
    'ma',
    'che',
    'chi',
    'non',
    'si',
    'mi',
    'ti',
    'ci',
    'vi',
    'è',
    'sono',
    'ho',
    'hai',
    'ha',
    'abbiamo',
  };

  /// Returns up to [maxSentences] sentences from [text], in their
  /// original order, chosen by word-frequency score.
  ///
  /// Returns an empty list if [text] contains no sentences. If [text]
  /// has fewer than [maxSentences] sentences, every sentence is
  /// returned, still in original order.
  List<String> summarize(String text, {int maxSentences = 3}) {
    final sentences = _splitSentences(text);
    if (sentences.isEmpty) return const [];
    if (sentences.length <= maxSentences) return sentences;

    final wordScores = _scoreWords(sentences);
    final ranked = [
      for (var index = 0; index < sentences.length; index++)
        (index: index, score: _scoreSentence(sentences[index], wordScores)),
    ]..sort((a, b) => b.score.compareTo(a.score));

    final chosenIndexes = ranked.take(maxSentences).map((r) => r.index).toList()
      ..sort();

    return [for (final index in chosenIndexes) sentences[index]];
  }

  List<String> _splitSentences(String text) {
    return text
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();
  }

  Map<String, int> _scoreWords(List<String> sentences) {
    final scores = <String, int>{};
    for (final sentence in sentences) {
      for (final word in _wordsOf(sentence)) {
        scores[word] = (scores[word] ?? 0) + 1;
      }
    }
    return scores;
  }

  int _scoreSentence(String sentence, Map<String, int> wordScores) {
    var score = 0;
    for (final word in _wordsOf(sentence)) {
      score += wordScores[word] ?? 0;
    }
    return score;
  }

  Iterable<String> _wordsOf(String sentence) {
    return sentence
        .toLowerCase()
        .split(RegExp(r'[^\p{L}]+', unicode: true))
        .where((word) => word.isNotEmpty && !_stopWords.contains(word));
  }
}
