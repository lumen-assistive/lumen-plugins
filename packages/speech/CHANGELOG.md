# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.2.0] - 2026-10-25

### Added

- `SentenceBuilder`, joining a sequence of selected phrases into one
  composed, capitalized, punctuated sentence.
- `PhraseUsageTracker.mostUsedOverall`, ranking phrases by total use
  count with no recency weighting.

### Changed

- Renamed this package from `lumen_plugin_parlare` to `lumen_plugin_speech`,
  and its plugin class from `ParlarePlugin` to `SpeechPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Parlare`) is
  unchanged; only the package name, directory, class names, and manifest
  `id` changed.

## [0.1.0] - 2026-10-25

### Added

- `Phrase` and `PhraseBoard`: a categorized augmentative communication
  phrase board with a starting vocabulary covering needs, greetings,
  emotions, and emergency phrases.
- `PhraseUsageTracker`: ranks phrases by a recency-weighted frequency
  score, so a phrase used once recently can outrank one used often long
  ago.
- `SpeechPlugin`: wires the board and tracker together and exposes
  them directly, since `lumen_sdk` has no "phrase selected" event type.
