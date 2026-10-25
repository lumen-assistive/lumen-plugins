# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.2.0] - 2026-10-25

### Added

- `ItalianSyllableSplitter.splitText`, applying syllable splitting to
  every word in a block of text, rejoined with hyphens.
- `ReadingTimeEstimator`, estimating reading time in minutes from a
  word count or a block of text.

### Changed

- Renamed this package from `lumen_plugin_leggere` to `lumen_plugin_reading`,
  and its plugin class from `LeggerePlugin` to `ReadingPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Leggere e
  Studiare`) is unchanged; only the package name, directory, class
  names, and manifest `id` changed.

## [0.1.0] - 2026-10-25

### Added

- `ItalianSyllableSplitter`: splits an Italian word into syllables using
  the standard orthographic rules (s impura, digraphs, consonant
  blends).
- `SpacedRepetitionScheduler`, `Flashcard`, and `FlashcardDeck`: a
  correct implementation of the SM-2 spaced repetition algorithm.
- `ReadingPlugin`: wires the splitter and deck together and exposes
  them directly, since `lumen_sdk` has no matching event types.
