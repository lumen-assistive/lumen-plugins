import 'flashcard.dart';
import 'spaced_repetition_scheduler.dart';

/// A collection of [Flashcard]s reviewed with [SpacedRepetitionScheduler].
///
/// Takes no clock of its own: [due] and [review] both take the current
/// time as an explicit parameter, so tests control it directly instead
/// of this class reading the system clock.
class FlashcardDeck {
  /// Creates a deck, optionally starting from existing [cards] or a
  /// custom [scheduler] for testing.
  FlashcardDeck({List<Flashcard>? cards, SpacedRepetitionScheduler? scheduler})
      : _cards = {
          for (final card in cards ?? const <Flashcard>[]) card.id: card
        },
        _scheduler = scheduler ?? const SpacedRepetitionScheduler();

  final Map<String, Flashcard> _cards;
  final SpacedRepetitionScheduler _scheduler;

  /// Adds [card] to the deck, or replaces the existing card with the
  /// same [Flashcard.id] if there is one.
  void add(Flashcard card) {
    _cards[card.id] = card;
  }

  /// Every card in the deck.
  List<Flashcard> all() => _cards.values.toList(growable: false);

  /// Cards due for review at or before [now].
  List<Flashcard> due(DateTime now) => _cards.values
      .where((card) => !card.dueAt.isAfter(now))
      .toList(growable: false);

  /// Records a review of the card with [cardId] at [reviewedAt], of
  /// recall [quality] (0 to 5), applying the scheduler's outcome and
  /// scheduling the card's next [Flashcard.dueAt] that many days after
  /// [reviewedAt].
  void review(
      {required String cardId,
      required int quality,
      required DateTime reviewedAt}) {
    final card = _cards[cardId];
    if (card == null) {
      throw ArgumentError.value(
          cardId, 'cardId', 'No flashcard with this id in the deck');
    }

    final outcome = _scheduler.review(
      quality: quality,
      previousRepetitionCount: card.repetitionCount,
      previousIntervalDays: card.intervalDays,
      previousEasinessFactor: card.easinessFactor,
    );

    card
      ..repetitionCount = outcome.repetitionCount
      ..intervalDays = outcome.intervalDays
      ..easinessFactor = outcome.easinessFactor
      ..dueAt = reviewedAt.add(Duration(days: outcome.intervalDays));
  }
}
