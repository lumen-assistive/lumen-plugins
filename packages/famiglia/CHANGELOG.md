# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

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
- `FamigliaPlugin`, consent-gating caregiver status alerts through
  `PluginContext.hasConsent`.

### Known limitations

- No actual delivery to a caregiver's device (push notifications,
  `lumen-server` sync) yet; see README for scope.
