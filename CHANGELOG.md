# Changelog

This file tracks repository-level changes (new packages added, CI and
governance changes). Each package under `packages/` keeps its own
`CHANGELOG.md` for package-level changes.

## [Unreleased]

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
