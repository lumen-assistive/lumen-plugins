# Changelog

This file tracks repository-level changes (new packages added, CI and
governance changes). Each package under `packages/` keeps its own
`CHANGELOG.md` for package-level changes.

## [Unreleased]

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
