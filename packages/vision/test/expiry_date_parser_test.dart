import 'package:lumen_plugin_vision/lumen_plugin_vision.dart';
import 'package:test/test.dart';

void main() {
  late ExpiryDateParser parser;

  setUp(() {
    parser = ExpiryDateParser();
  });

  group('ExpiryDateParser', () {
    test('parses dd/mm/yyyy', () {
      final result = parser.parse('Consumare entro 25/12/2026 preferibilmente');
      expect(result.isFound, isTrue);
      expect(result.date, DateTime(2026, 12, 25));
      expect(result.format, ExpiryDateFormat.entroIlPhrase);
    });

    test('parses plain dd/mm/yyyy without a surrounding phrase', () {
      final result = parser.parse('Lotto L123 25/12/2026');
      expect(result.date, DateTime(2026, 12, 25));
      expect(result.format, ExpiryDateFormat.dayMonthYearSlash);
    });

    test('parses dd/mm/yy with a two-digit year', () {
      final result = parser.parse('Lotto L123 25/12/26');
      expect(result.date, DateTime(2026, 12, 25));
    });

    test('parses dd-mm-yyyy', () {
      final result = parser.parse('Scadenza: 25-12-2026');
      expect(result.date, DateTime(2026, 12, 25));
      expect(result.format, ExpiryDateFormat.dayMonthYearDash);
    });

    test('parses dd.mm.yyyy, a European packaging separator', () {
      final result = parser.parse('Best before 25.12.2026');
      expect(result.date, DateTime(2026, 12, 25));
      expect(result.format, ExpiryDateFormat.dayMonthYearDot);
    });

    test('parses dd.mm.yy with a two-digit year', () {
      final result = parser.parse('Best before 25.12.26');
      expect(result.date, DateTime(2026, 12, 25));
    });

    test('parses "SCAD mm/yyyy" as the last day of that month', () {
      final result = parser.parse('SCAD 02/2028');
      expect(result.date, DateTime(2028, 2, 29));
      expect(result.format, ExpiryDateFormat.monthYearOnly);
    });

    test('parses "da consumarsi preferibilmente entro il gg/mm/aaaa"', () {
      final result = parser.parse(
        'Da consumarsi preferibilmente entro il 01/03/2027',
      );
      expect(result.date, DateTime(2027, 3, 1));
      expect(result.format, ExpiryDateFormat.entroIlPhrase);
    });

    test('parses an Italian month abbreviation', () {
      final result = parser.parse('Scad. 12 DIC 2026');
      expect(result.date, DateTime(2026, 12, 12));
      expect(result.format, ExpiryDateFormat.italianMonthName);
    });

    test('parses a full Italian month name, matching the abbreviation', () {
      final result = parser.parse('12 Dicembre 2026');
      expect(result.date, DateTime(2026, 12, 12));
    });

    test('returns not found for text with no date', () {
      final result = parser.parse('Ingredienti: farina, acqua, sale');
      expect(result.isFound, isFalse);
      expect(result.date, isNull);
      expect(result.format, isNull);
    });

    test('rejects an invalid day for the given month', () {
      final result = parser.parse('31/02/2026');
      expect(result.isFound, isFalse);
    });

    test('rejects an invalid month number', () {
      final result = parser.parse('25/13/2026');
      expect(result.isFound, isFalse);
    });

    test('parses an already-past date without special handling', () {
      final result = parser.parse('Scadenza: 01/01/2020');
      expect(result.date, DateTime(2020, 1, 1));
    });
  });
}
