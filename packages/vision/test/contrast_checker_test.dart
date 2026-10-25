import 'package:lumen_plugin_vision/lumen_plugin_vision.dart';
import 'package:test/test.dart';

void main() {
  const checker = ContrastChecker();

  group('ContrastChecker', () {
    test('black on white has the maximum contrast ratio of 21', () {
      final result = checker.check(
        const RgbColor(0, 0, 0),
        const RgbColor(255, 255, 255),
      );
      expect(result.ratio, closeTo(21.0, 0.01));
      expect(result.passes(WcagLevel.aaa), isTrue);
    });

    test('identical colors have the minimum contrast ratio of 1', () {
      final result = checker.check(
        const RgbColor(128, 128, 128),
        const RgbColor(128, 128, 128),
      );
      expect(result.ratio, closeTo(1.0, 0.01));
      expect(result.passes(WcagLevel.aa), isFalse);
    });

    test('is symmetric regardless of which color is passed first', () {
      const a = RgbColor(20, 90, 160);
      const b = RgbColor(250, 245, 230);
      final forward = checker.check(a, b);
      final reversed = checker.check(b, a);
      expect(forward.ratio, closeTo(reversed.ratio, 0.0001));
    });

    test('large text passes AA at a lower ratio than normal text requires', () {
      // This app's own amber-on-cream accent, chosen for its AA contrast:
      // verifies the real design system claim rather than taking it on
      // faith.
      final result = checker.check(
        const RgbColor(0xB4, 0x53, 0x09),
        const RgbColor(0xFF, 0xFB, 0xF2),
        largeText: true,
      );
      expect(result.passes(WcagLevel.aa), isTrue);
    });

    test('a pale accent on a near-white background fails AA for normal text',
        () {
      final result = checker.check(
        const RgbColor(220, 210, 190),
        const RgbColor(255, 251, 242),
      );
      expect(result.passes(WcagLevel.aa), isFalse);
    });
  });
}
