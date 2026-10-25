<p align="center">
  <img src="https://raw.githubusercontent.com/lumen-assistive/.github/main/profile/assets/logo-wordmark.png" alt="Lumen" width="200">
</p>

# lumen-plugins

The plugin monorepo for [Lumen](https://github.com/lumen-assistive):
every module ships here, as an independent package under `packages/`,
rather than as a separate repository per module. New modules, from the
community or the core team, are added through pull requests. See
[CONTRIBUTING.md](CONTRIBUTING.md).

## Packages

| Package | Module | Status |
|---|---|---|
| [`packages/vedere`](packages/vedere) | Vedere (See) | Expiry date parsing and color naming; scene description, OCR beyond dates, banknote and medicine recognition deferred |
| [`packages/sentire`](packages/sentire) | Sentire (Hear) | Transcript sessions, heuristic summarizer, sound alert mapping; offline ASR and diarization deferred |
| [`packages/protezione`](packages/protezione) | Protezione (Safety) | Fall detector, SOS state machine, rules-based scam filter, emergency profile; live sensor wiring deferred |
| [`packages/famiglia`](packages/famiglia) | Famiglia e caregiver | Pairing, shared calendar, daily status, consent-gated alerts; caregiver-side delivery deferred |
| [`packages/parlare`](packages/parlare) | Parlare (Speak) | Augmentative communication phrase board with usage-ranked suggestions; text-to-speech output and pictogram images deferred |
| [`packages/leggere`](packages/leggere) | Leggere e Studiare (Read and Study) | Italian syllable splitting and SM-2 spaced repetition flashcards; reading scanned text aloud deferred |
| [`packages/ricordare`](packages/ricordare) | Ricordare (Remember) | Consent-gated person directory and recurring reminders; on-device face recognition deferred |
| [`packages/muoversi`](packages/muoversi) | Muoversi (Move) | Proactive gait stability monitoring and a mobility aid profile; live sensor wiring deferred |

Every package depends only on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk)'s public
contracts (`LumenPlugin`, `LumenEventBus`, `ModelRegistry`) pinned to a
tagged release, and never accesses sensors or models directly. Each
package's own README states plainly what it implements today and what
it defers, and why.

All eight modules on Lumen's roadmap now have a package here. Any
future module is added the same way: as a pull request, following
[CONTRIBUTING.md](CONTRIBUTING.md). This repository holds no empty
placeholder packages.

## History

Each of these four modules was originally developed in its own
repository (`lumen-plugin-vedere`, `-sentire`, `-protezione`,
`-famiglia`). They were consolidated here so that contributing a new
plugin, or improving an existing one, is a single, consistent pull
request workflow instead of four separately governed repositories. The
original repositories are archived with a pointer to this one.

## Development

Each package is independent; run commands from inside the package
directory you are working on:

```
cd packages/<name>
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
```

Install the shared commit message hook once, from the repository root:

```
git config core.hooksPath .githooks
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full workflow, including
how to add a new plugin.

## License

Apache License 2.0, see [LICENSE](LICENSE).
