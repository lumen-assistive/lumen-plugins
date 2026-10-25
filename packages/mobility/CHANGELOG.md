# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.2.0] - 2026-10-25

### Added

- `RestBreakPlanner`, suggesting rest break points within a planned
  walk, spaced according to guidance verbosity.
- `GaitStabilityMonitor` gained a `minimumStepsForAssessment` parameter
  (default 4), withholding an irregularity verdict entirely when too
  few steps were detected to trust one. `GaitWindowResult` gained a
  matching `hasEnoughData` field.

### Changed

- Renamed this package from `lumen_plugin_muoversi` to `lumen_plugin_mobility`,
  and its plugin class from `MuoversiPlugin` to `MobilityPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Muoversi`) is
  unchanged; only the package name, directory, class names, and manifest
  `id` changed.

## [0.1.0] - 2026-10-25

### Added

- `MobilityProfile` and `validateMobilityProfile`: the mobility aid a
  user relies on and their preferred guidance verbosity.
- `AccelerometerSample` and `GaitStabilityMonitor`: proactive step and
  cadence detection that flags irregular walking rhythm as a possible
  stumble risk, distinct from `lumen_plugin_safety`'s post-fall
  `FallDetector`.
- `MobilityPlugin`: wires the monitor together and exposes it directly,
  since `lumen_sdk` has no accelerometer event type yet.
