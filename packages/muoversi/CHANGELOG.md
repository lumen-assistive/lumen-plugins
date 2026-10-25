# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [0.1.0] - 2026-10-25

### Added

- `MobilityProfile` and `validateMobilityProfile`: the mobility aid a
  user relies on and their preferred guidance verbosity.
- `AccelerometerSample` and `GaitStabilityMonitor`: proactive step and
  cadence detection that flags irregular walking rhythm as a possible
  stumble risk, distinct from `lumen_plugin_protezione`'s post-fall
  `FallDetector`.
- `MuoversiPlugin`: wires the monitor together and exposes it directly,
  since `lumen_sdk` has no accelerometer event type yet.
