import 'package:lumen_sdk/lumen_sdk.dart';

import 'srs/flashcard_deck.dart';
import 'syllables/italian_syllable_splitter.dart';

/// Lumen's Leggere e Studiare (Read and Study) module: Italian syllable
/// splitting and spaced-repetition flashcards.
///
/// `lumen_sdk` has no event type for "word to split" or "card
/// reviewed", so this plugin exposes [syllableSplitter] and
/// [flashcardDeck] directly through getters, the same pattern
/// `FamigliaPlugin` uses for its calendar and status stores.
class LeggerePlugin implements LumenPlugin {
  /// Creates the plugin, optionally with a custom [syllableSplitter] or
  /// [flashcardDeck] for testing.
  LeggerePlugin(
      {ItalianSyllableSplitter? syllableSplitter, FlashcardDeck? flashcardDeck})
      : _syllableSplitter = syllableSplitter ?? const ItalianSyllableSplitter(),
        _flashcardDeck = flashcardDeck ?? FlashcardDeck();

  final ItalianSyllableSplitter _syllableSplitter;
  final FlashcardDeck _flashcardDeck;

  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'leggere',
    nameIt: 'Leggere e Studiare',
    nameEn: 'Read and Study',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [],
  );

  /// Splits Italian words into syllables.
  ItalianSyllableSplitter get syllableSplitter => _syllableSplitter;

  /// The learner's spaced-repetition flashcard deck.
  FlashcardDeck get flashcardDeck => _flashcardDeck;

  @override
  Future<void> initialize(PluginContext context) async {}

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
