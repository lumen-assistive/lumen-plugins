# lumen_plugin_family

Lumen's Family module (Italian: Famiglia e caregiver): remote
configuration, consent-gated alerts, shared calendar, "all ok today"
status, and roles and permissions, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

This package provides the local business logic and data model only:

- `CaregiverLink`, `PairingCodeGenerator`: pairing a caregiver account to
  a device with a short-lived, cryptographically random six-digit code.
- `CalendarEvent`, `CalendarStore`, `InMemoryCalendarStore`: a shared
  calendar abstraction supporting one-time, daily, and weekly recurring
  events; `lumen-app` provides the real, persistent store.
- `DailyStatus`, `DailyStatusTracker`: the "all ok today" status, which
  resets automatically when the day rolls over.
- `CaregiverRole`, `CaregiverAction`, `caregiverRoleAllows`: a simple
  permission table for what a viewer versus a manager caregiver may do.
- `CaregiverNotificationComposer`: builds the plain-text notification a
  caregiver is shown from a `DailyStatus` and the upcoming
  `CalendarEvent`s, without deciding how or whether it is delivered.
- `FamilyPlugin`: wires the above into the `lumen_sdk` plugin
  lifecycle, and only tells a caregiver about the user's status through
  `PluginContext.hasConsent` gating consent for
  `shareStatusWithCaregiverConsentKey`. Without that consent, nothing is
  ever published.

## Current scope

This package does not implement actual delivery of alerts, calendar
sync, or configuration changes to a caregiver's own device. That
requires `lumen-server` (to relay data between devices) and `lumen-app`
(to run this package and talk to `lumen-server`), neither of which this
package depends on. This package only decides *whether* and *what* to
share, never *how* it reaches another device.

## Installation

```yaml
dependencies:
  lumen_plugin_family:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.3.0
      path: packages/family
```

## Development

Run from this directory (`packages/family`):

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
