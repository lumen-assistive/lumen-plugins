import 'dart:math' as math;

class _Usage {
  _Usage({required this.count, required this.lastUsedAt});

  int count;
  DateTime lastUsedAt;
}

/// Ranks phrases by how likely they are to be wanted next, so the most
/// useful ones surface first on a board that may hold dozens of them.
///
/// The ranking is a recency-weighted frequency score: each use counts
/// in full at the moment it happens, and that contribution halves every
/// [Duration] passed as `recencyHalfLife` to [topSuggestions] (a day, by
/// default). A phrase used often but only in the distant past is
/// eventually overtaken by one used just once recently, since a
/// person's immediate needs usually matter more than their historical
/// habits. This is this package's own heuristic, not a published
/// algorithm.
class PhraseUsageTracker {
  /// Creates a tracker. [now] defaults to [DateTime.now]; tests pass a
  /// fixed or steppable clock instead.
  PhraseUsageTracker({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Map<String, _Usage> _usage = {};

  /// Records that the phrase with [phraseId] was used right now.
  void recordUse(String phraseId) {
    final existing = _usage[phraseId];
    _usage[phraseId] =
        _Usage(count: (existing?.count ?? 0) + 1, lastUsedAt: _now());
  }

  /// The ids of up to [limit] phrases most likely to be wanted next,
  /// highest-ranked first, using a half-life of [recencyHalfLife] for
  /// how quickly older uses stop counting.
  ///
  /// Returns an empty list if no phrase has been used yet.
  List<String> topSuggestions(
      {int limit = 5, Duration recencyHalfLife = const Duration(hours: 24)}) {
    final now = _now();
    final halfLifeMs = recencyHalfLife.inMilliseconds;

    final scored = _usage.entries.map((entry) {
      final ageMs = now.difference(entry.value.lastUsedAt).inMilliseconds;
      final halfLivesElapsed = ageMs / halfLifeMs;
      final score = entry.value.count * math.pow(0.5, halfLivesElapsed);
      return MapEntry(entry.key, score);
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return scored.take(limit).map((entry) => entry.key).toList(growable: false);
  }

  /// The ids of up to [limit] phrases with the highest total use count,
  /// with no recency weighting, ties broken by whichever was used most
  /// recently.
  ///
  /// Where [topSuggestions] favors what is relevant right now,
  /// `mostUsedOverall` answers a different question a caregiver
  /// reviewing the board is more likely to ask: which phrases matter
  /// most in general, regardless of a recent lull in use.
  ///
  /// Returns an empty list if no phrase has been used yet.
  List<String> mostUsedOverall({int limit = 5}) {
    final sorted = _usage.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.count.compareTo(a.value.count);
        if (byCount != 0) return byCount;
        return b.value.lastUsedAt.compareTo(a.value.lastUsedAt);
      });

    return sorted.take(limit).map((entry) => entry.key).toList(growable: false);
  }
}
