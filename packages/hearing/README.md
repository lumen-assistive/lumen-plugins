# lumen_plugin_hearing

Lumen's Hearing module (Italian: Sentire): offline live caption aggregation, sound
alert presentation mapping, and transcript session summaries, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

## Current scope

This package is pure Dart and implements the parts of Hearing that do
not require on-device machine learning models or native sensor access:

- `TranscriptSession`: aggregates final transcript segments into a
  session with a start time, end time, concatenated text, and word
  count.
- `Summarizer`: a word-frequency extractive heuristic that picks the
  most representative sentences out of a transcript. This is a plain
  heuristic, not a machine-learned summarizer, and is meant as a
  placeholder until an on-device summarization model is integrated
  through `lumen-core`.
- `AlertPresentationMapper`: maps a recognized sound label (doorbell,
  smoke alarm, siren, baby crying) to a vibration pattern, whether to
  flash the screen, and a severity, for `lumen-app` to act on.
- `CaptionFormatter`: wraps transcript text into caption-sized lines,
  breaking only at word boundaries, for a live-captioning display.
- `HearingPlugin`: wires the above to `lumen_sdk`'s `TranscriptEvent`
  and `SoundAlertEvent`.

**Not implemented yet, and why:** offline automatic speech recognition
(whisper.cpp) and non-speech sound classification (YAMNet) are not
implemented. Both need native audio capture and on-device model
inference bridges that do not exist yet in `lumen-core` (see that
repository's README for its current scope). Speaker diarization has
the same dependency. Until those bridges exist, nothing actually
publishes real `TranscriptEvent`s or `SoundAlertEvent`s on-device; this
package is ready to consume them the moment something does.

## Installation

```yaml
dependencies:
  lumen_plugin_hearing:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.3.0
      path: packages/hearing
```

## Development

Run from this directory (`packages/hearing`):

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
