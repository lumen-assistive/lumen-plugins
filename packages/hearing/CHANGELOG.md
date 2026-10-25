# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.2.0] - 2026-10-25

### Added

- `CaptionFormatter`, wrapping transcript text into caption-sized lines
  that never break a word across two lines.

### Changed

- Renamed this package from `lumen_plugin_sentire` to `lumen_plugin_hearing`,
  and its plugin class from `SentirePlugin` to `HearingPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Sentire`) is
  unchanged; only the package name, directory, class names, and manifest
  `id` changed.
- `Summarizer.summarize` gained a `minSentenceLength` parameter (default
  8 characters) excluding trivially short sentences from being chosen as
  representative, since one could previously outrank a genuinely longer
  sentence by sharing a single common word.

## [0.1.0] - 2026-10-23

### Added

- `TranscriptSession` to aggregate final transcript segments into a
  session summary.
- `Summarizer`, a word-frequency extractive heuristic for transcript
  text.
- `AlertPresentationMapper` to map recognized sound labels to a
  vibration/flash/severity presentation, with a conservative fallback.
- `HearingPlugin` wiring the above to `lumen_sdk`'s `TranscriptEvent`
  and `SoundAlertEvent`.

### Known limitations

- No offline ASR (whisper.cpp), sound classification (YAMNet), or
  speaker diarization yet; see README for why.
