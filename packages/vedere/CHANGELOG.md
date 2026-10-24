# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [0.1.0] - 2026-10-23

### Added

- `ExpiryDateParser`, recognizing expiry dates across several formats
  seen on Italian packaging.
- `ColorNamer`, mapping an RGB sample to the nearest of a fixed set of
  Italian color names.
- `VederePlugin`, a `LumenPlugin` wiring `ExpiryDateParser` to
  `lumen_sdk`'s `OcrResultEvent`.

### Known limitations

- No scene description, live OCR beyond date parsing, banknote
  recognition, medicine box or leaflet question answering, obstacle
  detection, or "find" mode yet; see README for why.
