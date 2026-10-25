import 'package:lumen_plugin_speech/lumen_plugin_speech.dart';
import 'package:test/test.dart';

void main() {
  const builder = SentenceBuilder();

  const water = Phrase(
    id: 'needs-water',
    textIt: 'acqua',
    textEn: 'water',
    category: PhraseCategory.needs,
  );
  const please = Phrase(
    id: 'greetings-please',
    textIt: 'per favore',
    textEn: 'please',
    category: PhraseCategory.greetings,
  );
  const help = Phrase(
    id: 'emergency-help',
    textIt: 'aiuto!',
    textEn: 'help!',
    category: PhraseCategory.emergency,
  );

  group('SentenceBuilder', () {
    test('returns an empty string for no phrases', () {
      expect(builder.compose(const []), '');
    });

    test('capitalizes the first word and adds a trailing period', () {
      expect(builder.compose([water]), 'Water.');
    });

    test('joins multiple phrases with spaces', () {
      expect(builder.compose([water, please]), 'Water please.');
    });

    test('does not add a period when the last phrase already has one', () {
      expect(builder.compose([please, help]), 'Please help!');
    });

    test('composes in Italian when asked', () {
      expect(
        builder.compose([water, please], locale: SentenceLocale.it),
        'Acqua per favore.',
      );
    });
  });
}
