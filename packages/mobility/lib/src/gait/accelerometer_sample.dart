import 'dart:math' as math;

/// A single 3-axis accelerometer reading, in meters per second squared,
/// at a point in time.
///
/// Defined locally rather than in `lumen_sdk` because the SDK does not
/// yet define a raw accelerometer event, the same reason
/// `lumen_plugin_safety. defines its own copy for `FallDetector`..
/// Once `lumen_sdk` gains a shared accelerometer event type, both
/// packages are expected to migrate to it.
class AccelerometerSample {
  /// Creates a sample.
  const AccelerometerSample(
      {required this.x,
      required this.y,
      required this.z,
      required this.timestamp});

  /// Acceleration along the X axis, in meters per second squared.
  final double x;

  /// Acceleration along the Y axis, in meters per second squared.
  final double y;

  /// Acceleration along the Z axis, in meters per second squared.
  final double z;

  /// When this sample was captured.
  final DateTime timestamp;

  /// Magnitude of the acceleration vector.
  double get magnitude => math.sqrt(x * x + y * y + z * z);
}
