# Changelog

This file tracks repository-level changes (new packages added, CI and
governance changes). Each package under `packages/` keeps its own
`CHANGELOG.md` for package-level changes.

## [Unreleased]

## [0.3.0] - 2026-10-25

### Changed

- Renamed every package's internal identifiers from Italian to English,
  across this repository and every other repository that consumes
  these packages:

  | Old package | New package | Old id | New id |
  |---|---|---|---|
  | `lumen_plugin_vedere` | `lumen_plugin_vision` | `vedere` | `vision` |
  | `lumen_plugin_sentire` | `lumen_plugin_hearing` | `sentire` | `hearing` |
  | `lumen_plugin_protezione` | `lumen_plugin_safety` | `protezione` | `safety` |
  | `lumen_plugin_famiglia` | `lumen_plugin_family` | `famiglia` | `family` |
  | `lumen_plugin_parlare` | `lumen_plugin_speech` | `parlare` | `speech` |
  | `lumen_plugin_leggere` | `lumen_plugin_reading` | `leggere` | `reading` |
  | `lumen_plugin_ricordare` | `lumen_plugin_memory` | `ricordare` | `memory` |
  | `lumen_plugin_muoversi` | `lumen_plugin_mobility` | `muoversi` | `mobility` |

  Each `PluginManifest.nameIt` is unchanged (the real Italian product
  name); only package names, directories, class names, and manifest
  `id`s changed. `nameEn` is now a consistent English label for every
  module (`Vedere`/`Sentire`/`Protezione` previously still showed their
  Italian name even in the English locale).

### Added

- A new, real, tested function in every package: `ContrastChecker`
  (vision), `CaptionFormatter` (hearing), `CheckInScheduler` (safety),
  `CaregiverNotificationComposer` (family), `SentenceBuilder` (speech),
  `ReadingTimeEstimator` (reading), `RoutineChecklistTracker` (memory),
  `RestBreakPlanner` (mobility).
- A real improvement to one existing function in every package:
  `ExpiryDateParser` recognizes a `dd.mm.yyyy` separator; `Summarizer`
  excludes trivially short sentences from selection; `ScamFilter`
  checks three more indicators and reports each one individually
  instead of one canned paragraph; `CalendarEvent`/`CalendarStore`
  support daily and weekly recurrence; `PhraseUsageTracker` gained
  `mostUsedOverall`; `ItalianSyllableSplitter` gained `splitText`;
  `ReminderScheduler` gained `snooze`; `GaitStabilityMonitor` withholds
  a verdict below a configurable minimum step count.

## [0.2.0] - 2026-10-25

### Added

- `packages/parlare`: an augmentative communication phrase board
  (`Phrase`, `PhraseBoard`) with usage-ranked suggestions
  (`PhraseUsageTracker`), and `ParlarePlugin`. Text-to-speech output and
  pictogram images are not implemented; see the package README.
- `packages/leggere`: Italian syllable splitting
  (`ItalianSyllableSplitter`) and SM-2 spaced repetition flashcards
  (`SpacedRepetitionScheduler`, `Flashcard`, `FlashcardDeck`), and
  `LeggerePlugin`. Reading scanned text aloud is not implemented; see
  the package README.
- `packages/ricordare`: a consent-gated person directory
  (`PersonProfile`, `PersonDirectory`) and recurring reminders
  (`Reminder`, `ReminderScheduler`), and `RicordarePlugin`. Real
  on-device face recognition is not implemented; see the package
  README.
- `packages/muoversi`: proactive gait stability monitoring
  (`AccelerometerSample`, `GaitStabilityMonitor`) and a mobility aid
  profile (`MobilityProfile`), and `MuoversiPlugin`. Live sensor wiring
  is not implemented, the same limitation `packages/protezione` has;
  see the package README.
- Added the four new packages to the CI matrix.

All eight modules on Lumen's roadmap now have a package in this
monorepo.

## [0.1.0] - 2026-10-24

### Added

- Consolidated `lumen-plugin-vedere`, `lumen-plugin-sentire`,
  `lumen-plugin-protezione`, and `lumen-plugin-famiglia` into this
  monorepo, as `packages/vedere`, `packages/sentire`,
  `packages/protezione`, and `packages/famiglia`. Each package's code,
  tests, and changelog carried over unchanged; only `pubspec.yaml`
  repository links and installation instructions were updated to point
  here.
- A CI workflow testing each package independently (matrix over the
  four packages) plus the organization's content guard.
- `CONTRIBUTING.md` describing how to add a new plugin package and the
  pull request review process.
- `CODEOWNERS` requesting review automatically on every pull request.
