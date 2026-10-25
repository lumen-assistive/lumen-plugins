import 'phrase.dart';

/// Manages the set of phrases shown on an augmentative communication
/// board.
///
/// Starts from [defaultPhrases], a small starting vocabulary covering
/// every [PhraseCategory]. This is a starting point, not a closed set:
/// `lumen-app` is expected to let a user or caregiver add their own
/// phrases with [add] once that editing interface exists.
class PhraseBoard {
  /// Creates a board. Starts from [defaultPhrases] unless a different
  /// starting set of [phrases] is given, which test code uses to avoid
  /// depending on the exact default vocabulary.
  PhraseBoard({List<Phrase>? phrases})
      : _phrases = {
          for (final phrase in phrases ?? defaultPhrases) phrase.id: phrase
        };

  final Map<String, Phrase> _phrases;

  /// The starting vocabulary every new board ships with, covering every
  /// [PhraseCategory] with a handful of common, concrete phrases.
  static final List<Phrase> defaultPhrases = [
    const Phrase(
        id: 'needs-water',
        textIt: 'Acqua',
        textEn: 'Water',
        category: PhraseCategory.needs),
    const Phrase(
        id: 'needs-bathroom',
        textIt: 'Bagno',
        textEn: 'Bathroom',
        category: PhraseCategory.needs),
    const Phrase(
        id: 'needs-hungry',
        textIt: 'Ho fame',
        textEn: "I'm hungry",
        category: PhraseCategory.needs),
    const Phrase(
        id: 'needs-tired',
        textIt: 'Sono stanco',
        textEn: "I'm tired",
        category: PhraseCategory.needs),
    const Phrase(
        id: 'needs-pain',
        textIt: 'Ho dolore',
        textEn: "I'm in pain",
        category: PhraseCategory.needs),
    const Phrase(
      id: 'greetings-hello',
      textIt: 'Ciao',
      textEn: 'Hello',
      category: PhraseCategory.greetings,
    ),
    const Phrase(
      id: 'greetings-goodbye',
      textIt: 'Arrivederci',
      textEn: 'Goodbye',
      category: PhraseCategory.greetings,
    ),
    const Phrase(
      id: 'greetings-thank-you',
      textIt: 'Grazie',
      textEn: 'Thank you',
      category: PhraseCategory.greetings,
    ),
    const Phrase(
      id: 'greetings-please',
      textIt: 'Per favore',
      textEn: 'Please',
      category: PhraseCategory.greetings,
    ),
    const Phrase(
        id: 'greetings-yes',
        textIt: 'Si',
        textEn: 'Yes',
        category: PhraseCategory.greetings),
    const Phrase(
        id: 'greetings-no',
        textIt: 'No',
        textEn: 'No',
        category: PhraseCategory.greetings),
    const Phrase(
      id: 'emotions-happy',
      textIt: 'Sono felice',
      textEn: "I'm happy",
      category: PhraseCategory.emotions,
    ),
    const Phrase(
      id: 'emotions-sad',
      textIt: 'Sono triste',
      textEn: "I'm sad",
      category: PhraseCategory.emotions,
    ),
    const Phrase(
      id: 'emotions-scared',
      textIt: 'Ho paura',
      textEn: "I'm scared",
      category: PhraseCategory.emotions,
    ),
    const Phrase(
      id: 'emotions-angry',
      textIt: 'Sono arrabbiato',
      textEn: "I'm angry",
      category: PhraseCategory.emotions,
    ),
    const Phrase(
        id: 'emergency-help',
        textIt: 'Aiuto',
        textEn: 'Help',
        category: PhraseCategory.emergency),
    const Phrase(
      id: 'emergency-call-doctor',
      textIt: 'Chiama un medico',
      textEn: 'Call a doctor',
      category: PhraseCategory.emergency,
    ),
    const Phrase(
      id: 'emergency-call-family',
      textIt: 'Chiama la mia famiglia',
      textEn: 'Call my family',
      category: PhraseCategory.emergency,
    ),
    const Phrase(
      id: 'emergency-not-well',
      textIt: 'Non mi sento bene',
      textEn: "I don't feel well",
      category: PhraseCategory.emergency,
    ),
  ];

  /// Every phrase currently on the board.
  List<Phrase> all() => _phrases.values.toList(growable: false);

  /// Phrases under [category], in no particular order.
  List<Phrase> byCategory(PhraseCategory category) => _phrases.values
      .where((phrase) => phrase.category == category)
      .toList(growable: false);

  /// The phrase with [id], or `null` if the board has none with that id.
  Phrase? byId(String id) => _phrases[id];

  /// Adds [phrase] to the board, or replaces the existing phrase with
  /// the same [Phrase.id] if there is one.
  void add(Phrase phrase) {
    _phrases[phrase.id] = phrase;
  }
}
