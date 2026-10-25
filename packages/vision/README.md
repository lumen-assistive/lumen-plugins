# lumen_plugin_vision

Lumen's Vision module (Italian: Vedere): on-device utilities for reading expiry
dates from OCR text and naming colors, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

## Current scope

This package is pure Dart and implements only what is real and
testable today:

- `ExpiryDateParser`: extracts an expiry date from OCR text across
  several formats seen on Italian and wider European packaging
  (`dd/mm/yyyy`, `dd-mm-yyyy`, `dd.mm.yyyy`, `SCAD mm/yyyy`,
  `da consumarsi preferibilmente entro il gg/mm/aaaa`, and Italian
  month names).
- `ColorNamer`: maps an RGB sample to the nearest of a small, fixed set
  of Italian color names.
- `ContrastChecker`: computes the real WCAG 2.x contrast ratio between
  two colors and checks it against the AA and AAA thresholds, so the
  app's own design system claims can be verified against arbitrary
  colors rather than taken on faith.
- `VisionPlugin`: a `LumenPlugin` that subscribes to `lumen_sdk`'s
  `OcrResultEvent` and publishes an `AlertEvent` when `ExpiryDateParser`
  finds a date in the recognized text.

### What is not implemented yet, and why

The original Vision module also covers scene description, live OCR
beyond date parsing, euro banknote recognition, medicine box and
leaflet question answering, obstacle detection, and a "find" mode.
None of these are implemented yet:

- They require on-device vision models (object detection, a small
  language model for leaflet Q&A) that will be produced by a future
  `lumen-models` phase, which has not started.
- They require native camera and vision bridges in `lumen-core`, which
  currently has no native sensor code by design (see `lumen-core`'s own
  README for why).

`ColorNamer` is included ahead of its sensor wiring for the same
reason: the naming logic is complete and tested, but `lumen_sdk` has no
color-sensing event type yet to feed it live samples.

## Installation

```yaml
dependencies:
  lumen_plugin_vision:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.3.0
      path: packages/vision
```

## Development

Run from this directory (`packages/vision`):

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
