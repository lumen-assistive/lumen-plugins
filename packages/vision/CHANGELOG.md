# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [0.2.0] - 2026-10-25

### Added

- `ContrastChecker`, computing the real WCAG 2.x contrast ratio between
  two colors and checking it against the AA and AAA thresholds.

### Changed

- Renamed this package from `lumen_plugin_vedere` to `lumen_plugin_vision`,
  and its plugin class from `VederePlugin` to `VisionPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Vedere`) is
  unchanged; only the package name, directory, class names, and manifest
  `id` changed.
- `ExpiryDateParser` now also recognizes the `dd.mm.yyyy` separator,
  common on packaging printed for the wider European market.

## [0.1.0] - 2026-10-23

### Added

- `ExpiryDateParser`, recognizing expiry dates across several formats
  seen on Italian packaging.
- `ColorNamer`, mapping an RGB sample to the nearest of a fixed set of
  Italian color names.
- `VisionPlugin`, a `LumenPlugin` wiring `ExpiryDateParser` to
  `lumen_sdk`'s `OcrResultEvent`.

### Known limitations

- No scene description, live OCR beyond date parsing, banknote
  recognition, medicine box or leaflet question answering, obstacle
  detection, or "find" mode yet; see README for why.
