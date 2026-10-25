import 'package:lumen_plugin_muoversi/lumen_plugin_muoversi.dart';
import 'package:test/test.dart';

AccelerometerSample _sample(int offsetMs, double magnitude) =>
    AccelerometerSample(
        x: magnitude,
        y: 0,
        z: 0,
        timestamp: DateTime(2026).add(Duration(milliseconds: offsetMs)));

void main() {
  group('GaitStabilityMonitor', () {
    const monitor = GaitStabilityMonitor();

    test('reports zero steps and no cadence for a still window', () {
      final samples = [_sample(0, 9.8), _sample(100, 9.8), _sample(200, 9.8)];

      final result = monitor.analyze(samples);

      expect(result.stepCount, 0);
      expect(result.cadenceStepsPerMinute, 0);
      expect(result.isIrregular, isFalse);
    });

    test('counts evenly spaced steps as regular', () {
      final samples = [
        _sample(0, 14),
        _sample(100, 9.8),
        _sample(500, 14),
        _sample(600, 9.8),
        _sample(1000, 14),
        _sample(1100, 9.8),
        _sample(1500, 14),
        _sample(1600, 9.8),
      ];

      final result = monitor.analyze(samples);

      expect(result.stepCount, 4);
      expect(result.cadenceStepsPerMinute, closeTo(160, 0.01));
      expect(result.isIrregular, isFalse);
    });

    test('flags unevenly spaced steps as irregular', () {
      final samples = [
        _sample(0, 14),
        _sample(100, 9.8),
        _sample(300, 14),
        _sample(400, 9.8),
        _sample(600, 14),
        _sample(700, 9.8),
        _sample(1800, 14),
        _sample(1900, 9.8),
      ];

      final result = monitor.analyze(samples);

      expect(result.stepCount, 4);
      expect(result.isIrregular, isTrue);
    });

    test('debounces a second rise within the minimum step interval', () {
      final samples = [
        _sample(0, 14),
        _sample(50, 9.8),
        _sample(80, 14), // too soon after the step at 0ms, not a new step
        _sample(150, 9.8),
        _sample(600, 14),
        _sample(700, 9.8),
      ];

      final result = monitor.analyze(samples);

      expect(result.stepCount, 2);
    });

    test('reports zero cadence and not irregular with fewer than two steps',
        () {
      final samples = [_sample(0, 14), _sample(100, 9.8)];

      final result = monitor.analyze(samples);

      expect(result.stepCount, 1);
      expect(result.cadenceStepsPerMinute, 0);
      expect(result.isIrregular, isFalse);
    });
  });
}
