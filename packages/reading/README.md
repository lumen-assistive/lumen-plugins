# lumen_plugin_reading

Lumen's Reading module (Italian: Leggere e Studiare): Italian syllable
splitting and spaced-repetition flashcards, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

## What this package implements

- **`ItalianSyllableSplitter`**: splits a single Italian word into
  syllables using the orthographic rules taught in Italian schools: a
  lone consonant between two vowels joins the following vowel, "s
  impura" is never split off the vowel that follows it, a small set of
  digraphs and consonant blends stay together, and any other consonant
  pair splits evenly. This follows the purely orthographic rules, not
  full lexical hyphenation: distinguishing a diphthong from a hiatus
  needs word stress, which spelling alone does not give; every run of
  adjacent vowels is kept as one syllable, a documented simplification.
- **`ItalianSyllableSplitter.splitText`**: applies the same splitting to
  every word in a block of text, keeping attached punctuation on the
  last syllable, so a whole sentence can be shown hyphenated rather
  than one word at a time.
- **`SpacedRepetitionScheduler`, `Flashcard`, `FlashcardDeck`**: a
  correct implementation of the SM-2 spaced repetition algorithm
  (Wozniak, 1985), the original SuperMemo formula, scoring each review
  by recall quality to compute the next interval and easiness factor.
- **`ReadingTimeEstimator`**: estimates how long a block of text takes
  to read, for study planning.
- **`ReadingPlugin`**: wires the splitter and deck together and exposes
  them directly through getters, since `lumen_sdk` has no event type
  for "word to split" or "card reviewed".

## Current scope

This package is a reading and study toolkit, not a text processing
pipeline. Two things explicitly **not** implemented:

- **Reading scanned text aloud.** This package has no text-to-speech
  output and no OCR integration; that would combine with
  `lumen_plugin_vision`'s OCR output and a speech engine that does not
  exist in `lumen-core` yet.
- **Dyslexia-specific text adaptation beyond syllable splitting**, for
  example font or spacing changes: those belong in `lumen-app`'s
  rendering layer, not in this package's text-processing logic.

## Installation

```yaml
dependencies:
  lumen_plugin_reading:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.3.0
      path: packages/reading
```

## Development

Run from this directory (`packages/reading`):

```
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
```

See the [repository root README](../../README.md) and
[CONTRIBUTING.md](../../CONTRIBUTING.md) for the monorepo workflow,
including how to add a new plugin package.

## License

Apache License 2.0, see the [repository root LICENSE](../../LICENSE).
