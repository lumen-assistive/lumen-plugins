# lumen_plugin_mobility

Lumen's Mobility module (Italian: Muoversi): proactive gait stability monitoring and
a mobility aid profile, built on
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk).

## What this package implements

- **`MobilityProfile` and `validateMobilityProfile`**: which mobility
  aid, if any, a user relies on, and how much detail they want from
  movement guidance.
- **`AccelerometerSample` and `GaitStabilityMonitor`**: detects steps
  from a window of accelerometer samples using a simple rising-threshold
  crossing, the same basic technique ordinary pedometers use, then
  flags the window as irregular when the coefficient of variation of
  step intervals crosses a documented threshold, as a proactive
  "possible stumble risk" signal. A configurable `minimumStepsForAssessment`
  (default 4) withholds that verdict entirely when too few steps were
  detected, rather than reporting one a handful of steps could make
  misleading either way. This is distinct in purpose from
  `lumen_plugin_safety`'s `FallDetector`: that detects the impact of
  a fall that already happened, this looks for unsteady walking before
  one does. Both the step detector and the irregularity check are this
  package's own heuristic, not a validated clinical gait analysis
  algorithm.
- **`RestBreakPlanner`**: suggests rest break points within a planned
  walk, spaced according to a `MobilityProfile`'s guidance verbosity.
- **`MobilityPlugin`**: wires the monitor together and exposes it
  directly through a getter.

## Current scope

`MobilityPlugin` registers with `lumen-core` but its `start`/`stop` are
no-ops, the same limitation `lumen_plugin_safety`'s
`SafetyPlugin` has: `lumen_sdk` does not yet define a raw
accelerometer event, so there is nothing on the event bus yet to wire
`GaitStabilityMonitor` to. The analysis logic above is complete and
tested in isolation, ready to be connected once that event type and the
corresponding native bridge exist.

## Installation

```yaml
dependencies:
  lumen_plugin_mobility:
    git:
      url: https://github.com/lumen-assistive/lumen-plugins.git
      ref: v0.3.0
      path: packages/mobility
```

## Development

Run from this directory (`packages/mobility`):

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
