import 'package:meta/meta.dart';

/// Category grouping a [Phrase] for quick navigation on a communication
/// board.
enum PhraseCategory {
  /// Everyday physical needs: water, food, the bathroom, rest.
  needs,

  /// Social openers and closers: hello, goodbye, thank you.
  greetings,

  /// How the person is feeling.
  emotions,

  /// Urgent phrases meant to get help quickly.
  emergency,
}

/// A single quick phrase on an augmentative communication board.
///
/// [pictogramId] is an identifier only, meant to match a symbol set's
/// own catalog, not an embedded image: no pictogram image set ships
/// with Lumen today, since the evaluated option (ARASAAC) is licensed
/// CC-BY-NC-SA and is not compatible with this project's Apache-2.0
/// distribution; see `lumen-models/docs/LICENSES.md`. The field is kept
/// so a future, compatible symbol set can be wired in without changing
/// this data model.
@immutable
class Phrase {
  /// Creates a phrase.
  const Phrase({
    required this.id,
    required this.textIt,
    required this.textEn,
    required this.category,
    this.pictogramId,
  });

  /// Stable, unique identifier, for example `needs-water`.
  final String id;

  /// The phrase as shown and, once text-to-speech exists, spoken, to
  /// Italian-speaking users, the app's primary locale.
  final String textIt;

  /// The phrase shown when the active locale falls back to English.
  final String textEn;

  /// Which section of the board this phrase appears under.
  final PhraseCategory category;

  /// Identifier of a symbol in an external pictogram set, if one is
  /// configured. Null when no symbol is associated with this phrase.
  final String? pictogramId;
}
