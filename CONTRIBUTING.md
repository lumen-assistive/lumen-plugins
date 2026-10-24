# Contributing to lumen-plugins

This repository is a monorepo: every Lumen module lives under
`packages/<name>/` as its own independent Dart package. See the
organization-wide
[CONTRIBUTING.md](https://github.com/lumen-assistive/.github/blob/main/CONTRIBUTING.md)
for conventions shared across the whole organization (commit style,
code standards, accessibility and privacy requirements). This file
covers what is specific to contributing a plugin.

## Setup

```
git config core.hooksPath .githooks
```

Each package manages its own dependencies independently:

```
cd packages/<name>
dart pub get
```

## Before sending a pull request

From inside the package directory you changed:

```
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
```

CI runs the same three commands for every package on every push and
pull request, plus a content check for AI-tool references and emoji.
Every pull request gets an automatic review request (see `CODEOWNERS`).

## Adding a new plugin

New modules are welcome. Before writing code, open an issue describing
the module, what it does for the person using Lumen, and which
`lumen_sdk` events and capabilities it needs, so the approach can be
discussed before you invest time in an implementation that might need
to change.

A new plugin is a pull request that adds a new `packages/<name>/`
directory with this shape:

```
packages/<name>/
  pubspec.yaml
  analysis_options.yaml
  lib/
    lumen_plugin_<name>.dart   # barrel file exporting the public API
    src/
      <name>_plugin.dart       # implements LumenPlugin
      ...
  test/
    ...
  README.md
  CHANGELOG.md
```

Requirements, checked in review:

1. **Package name**: `lumen_plugin_<name>`, matching the directory.
   `pubspec.yaml` sets `publish_to: none` (this is not published to
   pub.dev) and depends on `lumen_sdk` pinned to a tagged release,
   never to its `main` branch:
   ```yaml
   dependencies:
     lumen_sdk:
       git:
         url: https://github.com/lumen-assistive/lumen-sdk.git
         ref: v0.1.0
   ```
   If another project depends on your plugin directly (rather than
   through `lumen-app`), it points at this monorepo with a `path:` key:
   ```yaml
   dependencies:
     lumen_plugin_<name>:
       git:
         url: https://github.com/lumen-assistive/lumen-plugins.git
         ref: v0.1.0
         path: packages/<name>
   ```
2. **Only go through `lumen_sdk` contracts.** A plugin implements
   `LumenPlugin` (manifest, `initialize`, `start`, `stop`, `dispose`),
   subscribes to existing `SenseEvent` types on `LumenEventBus`, and
   requests models through `ModelRegistry`. A plugin never opens a
   camera, microphone, or other sensor directly, and never bundles a
   model itself.
3. **If you need a new event type or capability that `lumen_sdk`
   doesn't have yet**, open an issue or pull request against
   `lumen-sdk` first (see that repository). Land the contract change
   there, get it tagged, then build your plugin against the new tag.
   Do not invent a local workaround type inside your plugin package
   that duplicates what belongs in the shared SDK.
4. **Tests are required**, covering the package's actual logic, not
   just construction. If part of your module depends on
   infrastructure that does not exist yet (a native bridge, a model
   that has not been converted), it is fine to ship the business logic
   you can implement and test today and state plainly in the package's
   `README.md` what is deferred and why. See any existing package under
   `packages/` for the expected tone and level of honesty. Do not
   fabricate a feature that does not actually work.
5. **Licensing**: all code is Apache-2.0, matching the repository root
   `LICENSE`. If your plugin needs a model or dataset, it is not
   bundled here. `lumen-models` tracks model licensing separately, and
   a plugin only references a model by id through `ModelRegistry`.
6. **No AI tool references, no emoji, English for all code, comments,
   and documentation.** The commit-msg hook and CI's content check
   both enforce part of this; review enforces the rest.
7. **Accessibility and privacy are not optional.** If your plugin
   surfaces anything through `lumen-app` eventually, keep screen reader
   labels, consent gating (`PluginContext.hasConsent`), and on-device
   processing in mind from the start, even though UI wiring happens in
   a later pass.

## Review and merge

Pull requests are reviewed by the project maintainer (automatically
requested via `CODEOWNERS`). A plugin is merged once:

- CI is green for its package.
- The requirements above are met.
- The module's scope and any deferred parts are documented honestly in
  its `README.md`.

After merge, the package gets its own `CHANGELOG.md` entry and is
included in the next tagged release of this repository.
