# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.1.0] - 2026-10-23

### Added

- `FallDetector` and `AccelerometerSample`: a free-fall, impact,
  stillness fall-detection heuristic.
- `SosController`, `SmsSender`, `SosState`: a cancellable SOS countdown
  with no bundled real message sender, and `FakeSmsSender` for tests.
- `ScamFilter`, `ScamAssessment`, `ScamRiskLevel`: a rules-based scam
  message filter with bilingual explanations.
- `EmergencyProfile` and `validateEmergencyProfile`.
- `ProtezionePlugin`, registering the above with `lumen-core`.

### Known limitations

- `ProtezionePlugin` does not yet subscribe to any live sensor or SMS
  event: `lumen_sdk` has no such event types yet. See README.
- `ScamFilter` is a rules-based placeholder, not a trained classifier.
