# Changelog

All notable changes to this package are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org).

## [0.1.0] - 2026-10-25

### Added

- `PersonProfile`, `validatePersonProfile`, and `PersonDirectory`: a
  consent-gated record of people Lumen's user may want help
  remembering.
- `Reminder` and `ReminderScheduler`: one-time and recurring reminders,
  with a testable injected clock.
- `RicordarePlugin`: wires the directory and scheduler together, and
  publishes an alert for each reminder that becomes due.
