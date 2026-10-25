import 'package:lumen_plugin_safety/lumen_plugin_safety.dart';
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

    test('lists every matched indicator, not just a count', () {
      final result = filter.assess(
        'Il tuo conto bloccato. Invia subito il codice OTP per sbloccarlo.',
      );

      expect(result.matchedIndicators.length, 2);
      expect(
        result.matchedIndicators.map((i) => i.type),
        containsAll([
          ScamIndicatorType.urgency,
          ScamIndicatorType.codeRequest,
        ]),
      );
    });

    test('flags bank impersonation as a distinct indicator', () {
      final result = filter.assess(
        'Richiesta di verifica del tuo conto da parte della tua banca.',
      );

      expect(result.riskLevel, ScamRiskLevel.low);
      expect(
        result.matchedIndicators.single.type,
        ScamIndicatorType.bankImpersonation,
      );
    });

    test('flags a courier redelivery fee request', () {
      final result = filter.assess(
        'Il tuo pacco in giacenza: paga le spese di consegna qui.',
      );

      expect(result.riskLevel, ScamRiskLevel.low);
      expect(
        result.matchedIndicators.single.type,
        ScamIndicatorType.courierFee,
      );
    });

    test('flags a prize notification', () {
      final result = filter.assess('Congratulazioni, hai vinto un premio!');

      expect(result.riskLevel, ScamRiskLevel.low);
      expect(
        result.matchedIndicators.single.type,
        ScamIndicatorType.prizeNotification,
      );
    });

    test('an unflagged message has no matched indicators', () {
      final result = filter.assess('Ciao, ci vediamo alle 18 per il caffe?');

      expect(result.matchedIndicators, isEmpty);
    });
  });
}
