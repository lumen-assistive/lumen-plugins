/// A single spaced-repetition flashcard and its current scheduling
/// state.
///
/// Scheduling fields start at SM-2's own defaults for a brand new card:
/// an easiness factor of 2.5, zero prior repetitions, and a zero-day
/// interval, meaning it is due immediately. [dueAt] is set explicitly
/// by the caller rather than defaulting to the current time, so a deck
/// loaded from storage can restore exactly when each card was due
/// without this class reading the system clock itself.
class Flashcard {
  /// Creates a flashcard.
  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.dueAt,
    this.repetitionCount = 0,
    this.intervalDays = 0,
    this.easinessFactor = 2.5,
  });

  /// Stable, unique identifier.
  final String id;

  /// The prompt shown to the learner.
  final String front;

  /// The answer revealed after the learner attempts recall.
  final String back;

  /// When this card is next due for review.
  DateTime dueAt;

  /// How many reviews in a row have scored a quality of 3 or above.
  int repetitionCount;

  /// Days between the last two reviews, as computed by
  /// [SpacedRepetitionScheduler].
  int intervalDays;

  /// SM-2 easiness factor, never below 1.3.
  double easinessFactor;
}
