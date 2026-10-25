import 'package:lumen_plugin_hearing/lumen_plugin_hearing.dart';
import 'package:test/test.dart';

void main() {
  const formatter = CaptionFormatter();

  group('CaptionFormatter', () {
    test('returns a single line when the text already fits', () {
      final lines = formatter.wrap('Il gatto dorme', maxCharactersPerLine: 32);
      expect(lines, ['Il gatto dorme']);
    });

    test('wraps at word boundaries, never mid-word', () {
      final lines = formatter.wrap(
        'Il cane corre veloce nel grande giardino verde',
        maxCharactersPerLine: 16,
      );
      expect(lines, [
        'Il cane corre',
        'veloce nel',
        'grande giardino',
        'verde',
      ]);
      for (final line in lines) {
        expect(line.length, lessThanOrEqualTo(16));
      }
    });

    test('keeps a single word longer than the limit whole, on its own line',
        () {
      final lines = formatter.wrap(
        'Un supercalifragilisticexpialidocious giorno',
        maxCharactersPerLine: 10,
      );
      expect(lines, ['Un', 'supercalifragilisticexpialidocious', 'giorno']);
    });

    test('returns an empty list for blank text', () {
      expect(formatter.wrap('   '), isEmpty);
    });

    test('collapses repeated whitespace between words', () {
      final lines = formatter.wrap('Uno   due\tte', maxCharactersPerLine: 32);
      expect(lines, ['Uno due te']);
    });
  });
}
