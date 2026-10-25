import 'accelerometer_sample.dart';

/// Standard gravity, in meters per second squared.
const double _gravity = 9.8;

/// Detects a fall from a sequence of accelerometer samples using the
/// same free-fall, impact, stillness pattern used by commercial
/// phone and wearable fall-detection algorithms.
///
/// A fall is reported when, in order:
///
/// 1. The acceleration magnitude drops below [freeFallThreshold] for
///    at least [minFreeFallDuration] (the phone is airborne).
/// 2. Within [maxImpactDelay] after free fall ends, the magnitude
///    exceeds [impactThreshold] (impact with the ground or a surface).
/// 3. For at least [minStillnessDuration] after the impact, the
///    magnitude stays within [stillnessBand] of standard gravity (the
///    phone has come to rest, ruling out continued normal movement).
///
/// Requiring all three phases in order is what distinguishes an actual
/// fall from a hard step, sitting down quickly, or setting the phone
/// down: those produce an impact-like spike but skip the free-fall
/// phase, or are not followed by stillness.
class FallDetector {
  /// Creates a detector. Defaults are a reasonable starting point for
  /// a phone carried in a pocket; tune per device during QA.
  const FallDetector({
    this.freeFallThreshold = 2.0,
    this.minFreeFallDuration = const Duration(milliseconds: 300),
    this.impactThreshold = 25.0,
    this.maxImpactDelay = const Duration(milliseconds: 500),
    this.minStillnessDuration = const Duration(milliseconds: 1500),
    this.stillnessBand = 3.0,
  });

  /// Magnitude below which the phone is considered to be in free fall.
  final double freeFallThreshold;

  /// Minimum duration of a free-fall phase to count as a candidate.
  final Duration minFreeFallDuration;

  /// Magnitude above which a sample counts as an impact.
  final double impactThreshold;

  /// Maximum time after free fall ends in which an impact must occur.
  final Duration maxImpactDelay;

  /// Minimum duration the phone must stay still after impact.
  final Duration minStillnessDuration;

  /// Allowed deviation from standard gravity to still count as "still".
  final double stillnessBand;

  /// Returns the timestamp of the detected impact if [samples] (sorted
  /// by timestamp, ascending) contain a fall pattern, or `null` if they
  /// do not.
  DateTime? detect(List<AccelerometerSample> samples) {
    if (samples.length < 2) return null;

    DateTime? freeFallStart;
    DateTime? freeFallEnd;

    for (var i = 0; i < samples.length; i++) {
      final sample = samples[i];

      if (sample.magnitude < freeFallThreshold) {
        freeFallStart ??= sample.timestamp;
        freeFallEnd = sample.timestamp;
        continue;
      }

      if (freeFallStart != null && freeFallEnd != null) {
        final freeFallDuration = freeFallEnd.difference(freeFallStart);
        if (freeFallDuration >= minFreeFallDuration) {
          final impactTimestamp = _findImpact(samples, i, freeFallEnd);
          if (impactTimestamp != null &&
              _hasStillnessAfter(samples, impactTimestamp)) {
            return impactTimestamp;
          }
        }
      }

      freeFallStart = null;
      freeFallEnd = null;
    }

    return null;
  }

  DateTime? _findImpact(
    List<AccelerometerSample> samples,
    int fromIndex,
    DateTime freeFallEnd,
  ) {
    for (var i = fromIndex; i < samples.length; i++) {
      final sample = samples[i];
      if (sample.timestamp.difference(freeFallEnd) > maxImpactDelay) {
        return null;
      }
      if (sample.magnitude > impactThreshold) {
        return sample.timestamp;
      }
    }
    return null;
  }

  bool _hasStillnessAfter(
    List<AccelerometerSample> samples,
    DateTime impactTimestamp,
  ) {
    DateTime? stillStart;
    for (final sample in samples) {
      if (!sample.timestamp.isAfter(impactTimestamp)) continue;

      final deviation = (sample.magnitude - _gravity).abs();
      if (deviation <= stillnessBand) {
        stillStart ??= sample.timestamp;
        if (sample.timestamp.difference(stillStart) >= minStillnessDuration) {
          return true;
        }
      } else {
        stillStart = null;
      }
    }
    return false;
  }
}
