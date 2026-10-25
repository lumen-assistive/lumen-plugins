import 'package:lumen_plugin_reading/lumen_plugin_reading.dart';
import 'package:test/test.dart';

void main() {
  group('ItalianSyllableSplitter', () {
    const splitter = ItalianSyllableSplitter();

    final cases = <String, List<String>>{
      'casa': ['ca', 'sa'],
      'amico': ['a', 'mi', 'co'],
      'gatto': ['gat', 'to'],
      'anno': ['an', 'no'],
      'stella': ['stel', 'la'],
      'finestra': ['fi', 'ne', 'stra'],
      'sempre': ['sem', 'pre'],
      'pesce': ['pe', 'sce'],
      'figlio': ['fi', 'glio'],
      'agnello': ['a', 'gnel', 'lo'],
      'acqua': ['ac', 'qua'],
    };

    cases.forEach((word, expected) {
      test('splits "$word" into ${expected.join('-')}', () {
        expect(splitter.split(word), expected);
      });
    });

    test('does not split a monosyllabic word', () {
      expect(splitter.split('sport'), ['sport']);
      expect(splitter.split('ho'), ['ho']);
    });

    test('returns the word unchanged when it has no vowels', () {
      expect(splitter.split('mm'), ['mm']);
    });

    test('returns a single-character word unchanged', () {
      expect(splitter.split('a'), ['a']);
    });

    test('returns an empty string unchanged', () {
      expect(splitter.split(''), ['']);
    });
  });

  group('ItalianSyllableSplitter.splitText', () {
    const splitter = ItalianSyllableSplitter();

    test('splits every word in a phrase and rejoins with spaces', () {
      expect(splitter.splitText('casa amico'), 'ca-sa a-mi-co');
    });

    test('keeps punctuation attached to the word it followed', () {
      expect(splitter.splitText('casa, amico.'), 'ca-sa, a-mi-co.');
    });

    test('collapses repeated whitespace between words', () {
      expect(splitter.splitText('casa   amico'), 'ca-sa a-mi-co');
    });

    test('returns an empty string for blank text', () {
      expect(splitter.splitText('   '), '');
    });
  });
}
