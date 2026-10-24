import 'package:lumen_plugin_protezione/lumen_plugin_protezione.dart';
import 'package:test/test.dart';

void main() {
  group('ScamFilter', () {
    const filter = ScamFilter();

    test('flags a message combining urgency and a code request as high risk',
        () {
      final result = filter.assess(
        'Il tuo conto bloccato. Invia subito il codice OTP per sbloccarlo.',
      );

      expect(result.riskLevel, ScamRiskLevel.high);
      expect(result.reasonIt, isNotEmpty);
      expect(result.reasonEn, isNotEmpty);
    });

    test('flags a message with a code request and a short url as high risk',
        () {
      final result = filter.assess(
        'Conferma la password qui: https://bit.ly/abc123',
      );

      expect(result.riskLevel, ScamRiskLevel.high);
    });

    test('flags a message with only urgency language as low risk', () {
      final result = filter.assess('Ultimo avviso: aggiorna i tuoi dati.');

      expect(result.riskLevel, ScamRiskLevel.low);
    });

    test('does not flag an ordinary message', () {
      final result = filter.assess('Ciao, ci vediamo alle 18 per il caffe?');

      expect(result.riskLevel, ScamRiskLevel.none);
    });

    test('is case-insensitive for keyword matching', () {
      final result = filter.assess('CONTO BLOCCATO, invia il CODICE subito.');

      expect(result.riskLevel, ScamRiskLevel.high);
    });
  });
}
