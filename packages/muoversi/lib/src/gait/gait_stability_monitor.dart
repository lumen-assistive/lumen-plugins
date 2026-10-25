import 'dart:math' as math;

import 'package:meta/meta.dart';

import 'accelerometer_sample.dart';

/// Result of analyzing one window of accelerometer samples for gait
/// stability.
@immutable
class GaitWindowResult {
  /// Creates a result.
  const GaitWindowResult({
    required this.stepCount,
    required this.cadenceStepsPerMinute,
    required this.isIrregular,
  });

  /// Number of steps detected in the window.
  final int stepCount;

  /// Steps per minute, extrapolated from the time between the first and
  /// last detected step. Zero when fewer than two steps were detected,
  /// since a cadence needs at least one interval to measure.
  final double cadenceStepsPerMinute;

  /// Whether the spacing between steps was irregular enough to flag as
  /// a possible stumble risk, rather than a normal, fairly even walking
  /// rhythm.
  final bool isIrregular;
}

/// Flags irregular walking rhythm from a window of accelerometer
/// samples, as a proactive signal distinct from
/// `lumen_plugin_protezione`'s `FallDetector`: this looks for unsteady
/// gait before a fall happens, not for the impact of one that already
/// has.
///
/// Like `FallDetector`, this works on injected samples rather than a
/// live sensor feed, since `lumen_sdk` has no accelerometer event type
/// yet; see the package README for the plan to wire this to a live feed
/// once one exists.
///
/// Step detection (a rising threshold crossing, the same basic
/// technique simple pedometers use) and the irregularity check (the
/// coefficient of variation of step intervals) are this package's own
/// heuristic, not a validated clinical gait analysis algorithm: they
/// are a reasonable starting point for a proactive warning, not a
/// medical measurement.
class GaitStabilityMonitor {
  /// Creates a monitor with the given thresholds.
  const GaitStabilityMonitor({
    this.stepThreshold = 11.5,
    this.minStepInterval = const Duration(milliseconds: 250),
    this.irregularityCoefficientThreshold = 0.35,
  });

  /// Magnitude a sample must exceed, rising from below it, to count as
  /// a step. Set above standard gravity (9.8) so stillness and gentle
  /// movement do not register as steps.
  final double stepThreshold;

  /// Minimum time between two counted steps, so a single footfall's
  /// vibration is not counted more than once.
  final Duration minStepInterval;

  /// How large the coefficient of variation (standard deviation divided
  /// by the mean) of step intervals can be before a window is flagged
  /// as irregular.
  final double irregularityCoefficientThreshold;

  /// Analyzes [samples] (sorted by timestamp, ascending) covering one
  /// window of walking.
  GaitWindowResult analyze(List<AccelerometerSample> samples) {
    final stepTimestamps = _detectSteps(samples);

    if (stepTimestamps.length < 2) {
      return GaitWindowResult(
        stepCount: stepTimestamps.length,
        cadenceStepsPerMinute: 0,
        isIrregular: false,
      );
    }

    final intervals = <int>[];
    for (var i = 1; i < stepTimestamps.length; i++) {
      intervals.add(
          stepTimestamps[i].difference(stepTimestamps[i - 1]).inMilliseconds);
    }

    final windowMs =
        stepTimestamps.last.difference(stepTimestamps.first).inMilliseconds;
    final cadence =
        windowMs == 0 ? 0.0 : stepTimestamps.length / (windowMs / 60000);

    final meanMs = intervals.reduce((a, b) => a + b) / intervals.length;
    final variance = intervals
            .map((ms) => math.pow(ms - meanMs, 2))
            .reduce((a, b) => a + b) /
        intervals.length;
    final coefficientOfVariation =
        meanMs == 0 ? 0.0 : math.sqrt(variance) / meanMs;

    return GaitWindowResult(
      stepCount: stepTimestamps.length,
      cadenceStepsPerMinute: cadence,
      isIrregular: coefficientOfVariation > irregularityCoefficientThreshold,
    );
  }

  List<DateTime> _detectSteps(List<AccelerometerSample> samples) {
    final steps = <DateTime>[];
    DateTime? lastStep;
    var wasBelowThreshold = true;

    for (final sample in samples) {
      final isAbove = sample.magnitude > stepThreshold;
      if (isAbove && wasBelowThreshold) {
        if (lastStep == null ||
            sample.timestamp.difference(lastStep) >= minStepInterval) {
          steps.add(sample.timestamp);
          lastStep = sample.timestamp;
        }
      }
      wasBelowThreshold = !isAbove;
    }

    return steps;
  }
}
