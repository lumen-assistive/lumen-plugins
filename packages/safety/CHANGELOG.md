# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.2.0] - 2026-10-25

### Added

- `CheckInScheduler`, tracking when the user last checked in and
  whether they are overdue for another one, on a rolling interval
  rather than `lumen_plugin_family`'s once-a-day status.

### Changed

- Renamed this package from `lumen_plugin_protezione` to `lumen_plugin_safety`,
  and its plugin class from `ProtezionePlugin` to `SafetyPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Protezione`) is
  unchanged; only the package name, directory, class names, and manifest
  `id` changed.
- `ScamFilter` now checks three additional real indicators (bank
  impersonation, courier redelivery fee requests, prize notifications)
  and `ScamAssessment` reports every matched indicator individually
  through a new `matchedIndicators` list, instead of one canned
  paragraph chosen by how many indicators matched. `reasonIt`/`reasonEn`
  remain available as a joined summary for existing callers.

## [0.1.0] - 2026-10-23

### Added

- `FallDetector` and `AccelerometerSample`: a free-fall, impact,
  stillness fall-detection heuristic.
- `SosController`, `SmsSender`, `SosState`: a cancellable SOS countdown
  with no bundled real message sender, and `FakeSmsSender` for tests.
- `ScamFilter`, `ScamAssessment`, `ScamRiskLevel`: a rules-based scam
  message filter with bilingual explanations.
- `EmergencyProfile` and `validateEmergencyProfile`.
- `SafetyPlugin`, registering the above with `lumen-core`.

### Known limitations

- `SafetyPlugin` does not yet subscribe to any live sensor or SMS
  event: `lumen_sdk` has no such event types yet. See README.
- `ScamFilter` is a rules-based placeholder, not a trained classifier.
