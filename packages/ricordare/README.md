# lumen_plugin_ricordare

Lumen's Ricordare (Remember) module: a consent-gated person directory
and recurring reminders, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

## What this package implements

- **`PersonProfile` and `validatePersonProfile`**: a record of a person
  Lumen's user may want help remembering, with a consent flag and
  timestamp whose consistency is validated on every write.
- **`PersonDirectory`**: stores profiles and enforces the consent
  invariant, so a profile's consent state is never stored inconsistently.
- **`Reminder` and `ReminderScheduler`**: one-time and recurring (daily
  or weekly) reminders, with an injected clock for testability, the
  same pattern `DailyStatusTracker` uses in `lumen_plugin_famiglia`.
- **`RicordarePlugin`**: wires the directory and scheduler together,
  exposing both directly since `lumen_sdk` has no matching event types,
  and publishes an `AlertEvent` for each reminder that becomes due.

## Current scope

This package manages consent-gated metadata and reminders only. **Real
on-device face recognition is not implemented**: `lumen-core` has no
face recognition model or camera bridge yet. `PersonDirectory` exists
so the consent record around that future feature can be captured and
managed correctly ahead of time, consistent with this project's privacy
commitment that recognition will only ever run on-device with explicit,
revocable consent (see the main site's privacy page).

## Installation

```yaml
dependencies:
  lumen_plugin_ricordare:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.2.0
      path: packages/ricordare
```

## Development

Run from this directory (`packages/ricordare`):

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
