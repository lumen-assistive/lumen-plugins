# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [0.1.0] - 2026-10-25

### Added

- `ItalianSyllableSplitter`: splits an Italian word into syllables using
  the standard orthographic rules (s impura, digraphs, consonant
  blends).
- `SpacedRepetitionScheduler`, `Flashcard`, and `FlashcardDeck`: a
  correct implementation of the SM-2 spaced repetition algorithm.
- `LeggerePlugin`: wires the splitter and deck together and exposes
  them directly, since `lumen_sdk` has no matching event types.
