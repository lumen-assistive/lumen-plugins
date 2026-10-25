import 'package:lumen_plugin_reading/lumen_plugin_reading.dart';
import 'package:test/test.dart';

void main() {
  group('FlashcardDeck', () {
    test('a newly added card with a past due date is due', () {
      final deck = FlashcardDeck();
      deck.add(Flashcard(
          id: 'c1', front: 'gatto', back: 'cat', dueAt: DateTime(2026, 1, 1)));

      expect(deck.due(DateTime(2026, 1, 2)).map((c) => c.id), ['c1']);
    });

    test('a card due in the future is not due yet', () {
      final deck = FlashcardDeck();
      deck.add(Flashcard(
          id: 'c1', front: 'gatto', back: 'cat', dueAt: DateTime(2026, 2, 1)));

      expect(deck.due(DateTime(2026, 1, 1)), isEmpty);
    });

    test('review applies the scheduler outcome and reschedules dueAt', () {
      final deck = FlashcardDeck();
      deck.add(Flashcard(
          id: 'c1', front: 'gatto', back: 'cat', dueAt: DateTime(2026, 1, 1)));

      deck.review(cardId: 'c1', quality: 5, reviewedAt: DateTime(2026, 1, 1));

      final card = deck.all().single;
      expect(card.repetitionCount, 1);
      expect(card.intervalDays, 1);
      expect(card.dueAt, DateTime(2026, 1, 2));
    });

    test('reviewing an unknown card id throws', () {
      final deck = FlashcardDeck();

      expect(
        () => deck.review(
            cardId: 'missing', quality: 5, reviewedAt: DateTime(2026, 1, 1)),
        throwsArgumentError,
      );
    });
  });
}
