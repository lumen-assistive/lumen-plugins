# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.2.0] - 2026-10-25

### Added

- `RoutineChecklistTracker`, a repeatable daily checklist of named
  steps that resets at day rollover.
- `ReminderScheduler.snooze`, pushing a reminder's due time forward
  without affecting its recurrence or completion state.

### Changed

- Renamed this package from `lumen_plugin_ricordare` to `lumen_plugin_memory`,
  and its plugin class from `RicordarePlugin` to `MemoryPlugin`, as part of
  renaming every plugin's internal identifiers to English across the
  organization. The manifest's Italian display name (`Ricordare`) is
  unchanged; only the package name, directory, class names, and manifest
  `id` changed.

## [0.1.0] - 2026-10-25

### Added

- `PersonProfile`, `validatePersonProfile`, and `PersonDirectory`: a
  consent-gated record of people Lumen's user may want help
  remembering.
- `Reminder` and `ReminderScheduler`: one-time and recurring reminders,
  with a testable injected clock.
- `MemoryPlugin`: wires the directory and scheduler together, and
  publishes an alert for each reminder that becomes due.
