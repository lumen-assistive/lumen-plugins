import 'package:lumen_plugin_safety/lumen_plugin_safety.dart';
import 'package:test/test.dart';

AccelerometerSample _sample(int ms, double magnitude, DateTime base) {
  return AccelerometerSample(
    x: magnitude,
    y: 0,
    z: 0,
    timestamp: base.add(Duration(milliseconds: ms)),
  );
}

void main() {
  final base = DateTime(2026);
  const detector = FallDetector();

  group('FallDetector', () {
    test('detects a clear free-fall, impact, stillness sequence', () {
      final samples = [
        _sample(0, 9.8, base),
        _sample(50, 9.8, base),
        _sample(100, 0.5, base),
        _sample(200, 0.4, base),
        _sample(300, 0.3, base),
        _sample(450, 0.5, base),
        _sample(480, 30.0, base),
        _sample(600, 9.9, base),
        _sample(900, 9.7, base),
        _sample(1200, 9.8, base),
        _sample(1600, 9.85, base),
        _sample(2000, 9.8, base),
        _sample(2150, 9.8, base),
      ];

      final result = detector.detect(samples);

      expect(result, base.add(const Duration(milliseconds: 480)));
    });

    test('does not trigger on a hard impact without free fall', () {
      final samples = [
        _sample(0, 9.8, base),
        _sample(100, 9.8, base),
        _sample(200, 30.0, base),
        _sample(300, 9.8, base),
        _sample(600, 9.8, base),
        _sample(2000, 9.8, base),
      ];

      expect(detector.detect(samples), isNull);
    });

    test('does not trigger during normal walking', () {
      final samples = [
        _sample(0, 7.0, base),
        _sample(100, 12.0, base),
        _sample(200, 8.0, base),
        _sample(300, 11.0, base),
        _sample(400, 9.0, base),
        _sample(500, 10.0, base),
        _sample(600, 8.5, base),
      ];

      expect(detector.detect(samples), isNull);
    });

    test('does not trigger when free fall is too short', () {
      final samples = [
        _sample(0, 9.8, base),
        _sample(100, 0.5, base),
        _sample(150, 30.0, base),
        _sample(600, 9.8, base),
        _sample(2000, 9.8, base),
      ];

      expect(detector.detect(samples), isNull);
    });

    test('does not trigger without stillness after impact', () {
      final samples = [
        _sample(0, 9.8, base),
        _sample(100, 0.5, base),
        _sample(200, 0.4, base),
        _sample(450, 0.5, base),
        _sample(480, 30.0, base),
        _sample(600, 20.0, base),
        _sample(900, 18.0, base),
        _sample(1200, 22.0, base),
      ];

      expect(detector.detect(samples), isNull);
    });
  });
}
