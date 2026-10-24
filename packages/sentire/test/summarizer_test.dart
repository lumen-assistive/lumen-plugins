import 'package:lumen_plugin_sentire/lumen_plugin_sentire.dart';
import 'package:test/test.dart';

void main() {
  group('Summarizer', () {
    final summarizer = Summarizer();

    test('returns an empty list for empty text', () {
      expect(summarizer.summarize(''), isEmpty);
    });

    test('returns every sentence when under the limit', () {
      final result = summarizer.summarize(
        'Il medico arriva oggi. Porta le medicine.',
        maxSentences: 5,
      );
      expect(result, [
        'Il medico arriva oggi.',
        'Porta le medicine.',
      ]);
    });

    test('keeps original order when selecting top sentences', () {
      const text = 'Il gatto dorme sul divano. '
          'Il cane corre in giardino con il gatto. '
          'Oggi piove molto a Milano. '
          'Il gatto e il cane giocano insieme in giardino.';

      final result = summarizer.summarize(text, maxSentences: 2);

      expect(result.length, 2);
      // Sentences mentioning "gatto"/"cane"/"giardino" repeatedly should
      // outrank the one isolated weather sentence.
      expect(result, isNot(contains('Oggi piove molto a Milano.')));
      // Order in the result must match order of appearance in the text.
      final firstIndex = text.indexOf(result[0]);
      final secondIndex = text.indexOf(result[1]);
      expect(firstIndex, lessThan(secondIndex));
    });
  });
}
