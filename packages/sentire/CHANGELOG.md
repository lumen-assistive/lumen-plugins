# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.1.0] - 2026-10-23

### Added

- `TranscriptSession` to aggregate final transcript segments into a
  session summary.
- `Summarizer`, a word-frequency extractive heuristic for transcript
  text.
- `AlertPresentationMapper` to map recognized sound labels to a
  vibration/flash/severity presentation, with a conservative fallback.
- `SentirePlugin` wiring the above to `lumen_sdk`'s `TranscriptEvent`
  and `SoundAlertEvent`.

### Known limitations

- No offline ASR (whisper.cpp), sound classification (YAMNet), or
  speaker diarization yet; see README for why.
