# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.2.0] - 2026-10-25

### Added

- `CaregiverNotificationComposer`, building a plain-text caregiver
  notification from a `DailyStatus` and a list of upcoming
  `CalendarEvent`s.
- `CalendarEvent` gained a `recurrence` field (`none`, `daily`,
  `weekly`), and `InMemoryCalendarStore.listBetween` now expands a
  recurring event into one occurrence per matching date within the
  queried range.

### Changed

- Renamed this package from `lumen_plugin_famiglia` to `lumen_plugin_family`,
  and its plugin class from `FamigliaPlugin` to `FamilyPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Famiglia`) is
  unchanged; only the package name, directory, class names, and manifest
  `id` changed.

## [0.1.0] - 2026-10-23

### Added

- `CaregiverLink` and `PairingCodeGenerator` for caregiver pairing with
  short-lived, cryptographically random six-digit codes.
- `CalendarEvent`, `CalendarStore`, and `InMemoryCalendarStore` for the
  shared calendar.
- `DailyStatus` and `DailyStatusTracker` for the "all ok today" status
  with automatic day-rollover reset.
- `CaregiverRole`, `CaregiverAction`, and `caregiverRoleAllows` for
  viewer/manager permissions.
- `FamilyPlugin`, consent-gating caregiver status alerts through
  `PluginContext.hasConsent`.

### Known limitations

- No actual delivery to a caregiver's device (push notifications,
  `lumen-server` sync) yet; see README for scope.
