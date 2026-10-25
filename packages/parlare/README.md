# lumen_plugin_parlare

Lumen's Parlare (Speak) module: an augmentative communication phrase
board with usage-ranked suggestions, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

## What this package implements

- **`Phrase` and `PhraseBoard`**: a categorized phrase board (needs,
  greetings, emotions, emergency) with a starting vocabulary of common,
  concrete phrases in Italian and English. A caregiver or user is
  expected to extend it with `PhraseBoard.add` once `lumen-app` ships an
  editing interface.
- **`PhraseUsageTracker`**: ranks phrases by a recency-weighted
  frequency score, so a phrase used once recently can outrank one used
  often in the distant past. This is this package's own heuristic, not
  a published algorithm.
- **`ParlarePlugin`**: wires the board and tracker together and exposes
  them directly through getters, since `lumen_sdk` has no "phrase
  selected" event type for this to publish to instead.

## Current scope

This package manages the phrase data and its usage ranking only. Two
things a complete augmentative communication tool needs are explicitly
**not** implemented:

- **Text-to-speech output.** Selecting a phrase here only records its
  usage; it does not speak anything. `lumen-core` has no on-device
  speech synthesis engine yet.
- **Pictogram images.** `Phrase.pictogramId` is an identifier only, not
  an embedded image. The symbol set evaluated for this project,
  ARASAAC, is licensed CC-BY-NC-SA, which is not compatible with this
  project's Apache-2.0 distribution (see
  `lumen-models/docs/LICENSES.md`); no compatible symbol set has been
  bundled yet.

## Installation

```yaml
dependencies:
  lumen_plugin_parlare:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.2.0
      path: packages/parlare
```

## Development

Run from this directory (`packages/parlare`):

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
