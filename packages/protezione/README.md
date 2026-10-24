# lumen_plugin_protezione

Lumen's Protezione (Safety) module: fall detection, offline SOS, scam
filter, and emergency medical profile business logic, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

> Lumen helps but does not replace a doctor or the emergency number
> (112 in Italy), and it is not a certified medical device.

## What this package implements

- **`FallDetector`**: a free-fall, impact, stillness heuristic over a
  sequence of accelerometer samples, the same pattern used by
  commercial fall-detection algorithms. Fully unit tested, including
  cases that must *not* trigger (a hard step, sitting down quickly,
  normal walking).
- **`SosController`**: a cancellable countdown that, unless cancelled,
  hands an SOS message to an injected `SmsSender`. This package ships
  **no** real `SmsSender` implementation, on purpose: without one
  injected by the host app, this package cannot send a real message
  under any circumstances, including during tests. See
  `lib/lumen_plugin_protezione_testing.dart` for `FakeSmsSender`.
- **`ScamFilter`**: a rules-based, offline first pass at flagging
  likely SMS or message scams (urgency language, requests for codes or
  passwords, shortened URLs), with a plain-language reason in Italian
  and English for every verdict. This is explicitly not a trained
  classifier; see "Current scope" below.
- **`EmergencyProfile`** and `validateEmergencyProfile`: a data model
  and validator for the information an SOS message needs to be useful.

## Current scope

`ProtezionePlugin` registers with `lumen-core` but its `start`/`stop`
are no-ops: `lumen_sdk` does not yet define a raw accelerometer event
or an incoming-SMS event, so there is nothing on the event bus yet to
wire `FallDetector` or `ScamFilter` to. The logic above is complete and
tested in isolation, ready to be connected once those event types and
the corresponding native bridges exist in `lumen-core`. `ScamFilter`'s
rules-based approach is a first pass, not the trained on-device
classifier described in the long-term project plan.

## Installation

```yaml
dependencies:
  lumen_plugin_protezione:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.1.0
      path: packages/protezione
```

## Development

Run from this directory (`packages/protezione`):

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
