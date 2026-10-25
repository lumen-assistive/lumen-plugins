import 'package:lumen_plugin_parlare/lumen_plugin_parlare.dart';
import 'package:test/test.dart';

void main() {
  group('PhraseBoard', () {
    test('ships at least one default phrase in every category', () {
      final board = PhraseBoard();

      for (final category in PhraseCategory.values) {
        expect(
          board.byCategory(category),
          isNotEmpty,
          reason: '$category should have at least one default phrase',
        );
      }
    });

    test('finds a default phrase by id', () {
      final board = PhraseBoard();

      final phrase = board.byId('emergency-help');

      expect(phrase, isNotNull);
      expect(phrase!.category, PhraseCategory.emergency);
      expect(phrase.textEn, 'Help');
    });

    test('returns null for an unknown id', () {
      final board = PhraseBoard();

      expect(board.byId('does-not-exist'), isNull);
    });

    test('add appends a custom phrase alongside the defaults', () {
      final board = PhraseBoard();
      final before = board.all().length;

      board.add(
        const Phrase(
            id: 'custom-1',
            textIt: 'Prova',
            textEn: 'Test',
            category: PhraseCategory.needs),
      );

      expect(board.all().length, before + 1);
      expect(board.byId('custom-1')!.textEn, 'Test');
    });

    test('add replaces an existing phrase with the same id', () {
      final board = PhraseBoard();
      final before = board.all().length;

      board.add(
        const Phrase(
            id: 'needs-water',
            textIt: 'Acqua fresca',
            textEn: 'Cold water',
            category: PhraseCategory.needs),
      );

      expect(board.all().length, before);
      expect(board.byId('needs-water')!.textEn, 'Cold water');
    });

    test('can start from a custom starting set instead of the defaults', () {
      final board = PhraseBoard(
        phrases: [
          const Phrase(
              id: 'only-one',
              textIt: 'Unica',
              textEn: 'Only one',
              category: PhraseCategory.needs),
        ],
      );

      expect(board.all(), hasLength(1));
      expect(board.byId('needs-water'), isNull);
    });
  });
}
