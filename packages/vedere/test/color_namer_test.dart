import 'package:lumen_plugin_vedere/lumen_plugin_vedere.dart';
import 'package:test/test.dart';

void main() {
  late ColorNamer namer;

  setUp(() {
    namer = ColorNamer();
  });

  group('ColorNamer', () {
    test('names an exact table match', () {
      expect(namer.nameOf(const RgbColor(255, 255, 255)), 'bianco');
      expect(namer.nameOf(const RgbColor(0, 0, 0)), 'nero');
    });

    test('names a close-but-not-exact color', () {
      expect(namer.nameOf(const RgbColor(225, 25, 15)), 'rosso');
      expect(namer.nameOf(const RgbColor(15, 145, 25)), 'verde');
    });

    test('picks the nearer of two plausible neighbors', () {
      // Closer to the "grigio" table entry (130, 130, 130) than to
      // "bianco" (255, 255, 255) or "nero" (0, 0, 0).
      expect(namer.nameOf(const RgbColor(140, 140, 140)), 'grigio');
    });
  });
}
