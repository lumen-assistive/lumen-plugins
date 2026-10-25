import 'package:meta/meta.dart';

/// The result of scoring one review with [SpacedRepetitionScheduler.review].
@immutable
class ReviewOutcome {
  /// Creates an outcome.
  const ReviewOutcome({
    required this.intervalDays,
    required this.easinessFactor,
    required this.repetitionCount,
  });

  /// Days until the card should be reviewed again.
  final int intervalDays;

  /// The updated easiness factor, never below 1.3.
  final double easinessFactor;

  /// The updated consecutive-successful-review count, reset to zero by
  /// a quality below 3.
  final int repetitionCount;
}

/// Computes the next review interval for a flashcard using the SM-2
/// algorithm (Wozniak, 1985), the original SuperMemo spaced repetition
/// formula: a recall quality below 3 means the card was effectively
/// forgotten, resets the repetition count, and schedules a review the
/// next day; a quality of 3 or above advances the repetition count and
/// grows the interval (1 day, then 6 days, then the previous interval
/// times the easiness factor), while the easiness factor itself moves
/// up or down based on how easy or hard the recall felt, clamped to
/// never drop below SM-2's own floor of 1.3 (below which intervals
/// would shrink without bound).
class SpacedRepetitionScheduler {
  /// Creates a scheduler. Stateless: a single instance can be reused
  /// for any number of cards.
  const SpacedRepetitionScheduler();

  static const double _minEasinessFactor = 1.3;

  /// Scores a review of the given recall [quality] (0, complete
  /// blackout, to 5, perfect recall), given the card's previous state.
  ReviewOutcome review({
    required int quality,
    required int previousRepetitionCount,
    required int previousIntervalDays,
    required double previousEasinessFactor,
  }) {
    assert(quality >= 0 && quality <= 5, 'quality must be between 0 and 5');

    int repetitionCount;
    int intervalDays;

    if (quality < 3) {
      repetitionCount = 0;
      intervalDays = 1;
    } else {
      repetitionCount = previousRepetitionCount + 1;
      if (repetitionCount == 1) {
        intervalDays = 1;
      } else if (repetitionCount == 2) {
        intervalDays = 6;
      } else {
        intervalDays = (previousIntervalDays * previousEasinessFactor).round();
      }
    }

    final qualityDeficit = 5 - quality;
    var easinessFactor = previousEasinessFactor +
        (0.1 - qualityDeficit * (0.08 + qualityDeficit * 0.02));
    if (easinessFactor < _minEasinessFactor) {
      easinessFactor = _minEasinessFactor;
    }

    return ReviewOutcome(
      intervalDays: intervalDays,
      easinessFactor: easinessFactor,
      repetitionCount: repetitionCount,
    );
  }
}
