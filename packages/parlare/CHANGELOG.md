# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [0.1.0] - 2026-10-25

### Added

- `Phrase` and `PhraseBoard`: a categorized augmentative communication
  phrase board with a starting vocabulary covering needs, greetings,
  emotions, and emergency phrases.
- `PhraseUsageTracker`: ranks phrases by a recency-weighted frequency
  score, so a phrase used once recently can outrank one used often long
  ago.
- `ParlarePlugin`: wires the board and tracker together and exposes
  them directly, since `lumen_sdk` has no "phrase selected" event type.
