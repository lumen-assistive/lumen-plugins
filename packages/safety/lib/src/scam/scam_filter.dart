import 'scam_assessment.dart';
import 'scam_risk_level.dart';

/// A rules-based, offline first pass at flagging likely SMS or message
/// scams.
///
/// This is deliberately simple: a small set of documented keyword and
/// pattern checks, not a trained classifier. The project's long-term
/// plan calls for an on-device classifier; this filter is a safe,
/// explainable placeholder until that model exists as part of a future
/// `lumen-models` release, and every verdict comes with a reason so a
/// user is never told "this is a scam" without being told why.
class ScamFilter {
  /// Creates a filter with the built-in keyword and pattern lists.
  const ScamFilter();

  static const List<String> _urgencyKeywords = [
    'conto bloccato',
    'clicca subito',
    'vincita',
    'ultimo avviso',
    'sospensione immediata',
    'azione richiesta',
  ];

  static const List<String> _codeRequestKeywords = [
    'codice',
    'otp',
    'pin',
    'password',
  ];

  static const List<String> _bankImpersonationKeywords = [
    'la tua banca',
    'servizio clienti banca',
    'sicurezza bancaria',
    'verifica del tuo conto',
  ];

  static const List<String> _courierFeeKeywords = [
    'pacco in giacenza',
    'tassa doganale',
    'spese di consegna',
    'corriere espresso',
  ];

  static const List<String> _prizeNotificationKeywords = [
    'hai vinto',
    'congratulazioni ti sei aggiudicato',
    'premio in palio',
    'sei stato selezionato',
  ];

  static final RegExp _shortUrlPattern = RegExp(
    r'https?://(bit\.ly|tinyurl\.com|t\.co|goo\.gl)/\S+',
    caseSensitive: false,
  );

  /// Assesses [text], the body of an incoming SMS or message.
  ScamAssessment assess(String text) {
    final lower = text.toLowerCase();

    final matched = <ScamIndicator>[];

    if (_urgencyKeywords.any(lower.contains)) {
      matched.add(
        const ScamIndicator(
          type: ScamIndicatorType.urgency,
          reasonIt: 'Usa un tono urgente per farti agire senza pensarci.',
          reasonEn: 'It uses urgent language to make you act without thinking.',
        ),
      );
    }

    if (_codeRequestKeywords.any(lower.contains)) {
      matched.add(
        const ScamIndicator(
          type: ScamIndicatorType.codeRequest,
          reasonIt: 'Chiede un codice, un PIN o una password: nessuna banca '
              'o servizio reale li chiede mai via messaggio.',
          reasonEn: 'It asks for a code, PIN, or password: no real bank or '
              'service ever asks for these by message.',
        ),
      );
    }

    if (_shortUrlPattern.hasMatch(text)) {
      matched.add(
        const ScamIndicator(
          type: ScamIndicatorType.shortUrl,
          reasonIt: 'Contiene un link abbreviato che nasconde la vera '
              'destinazione.',
          reasonEn: 'It contains a shortened link hiding its real '
              'destination.',
        ),
      );
    }

    if (_bankImpersonationKeywords.any(lower.contains)) {
      matched.add(
        const ScamIndicator(
          type: ScamIndicatorType.bankImpersonation,
          reasonIt: 'Si finge una comunicazione della tua banca.',
          reasonEn: 'It poses as a message from your bank.',
        ),
      );
    }

    if (_courierFeeKeywords.any(lower.contains)) {
      matched.add(
        const ScamIndicator(
          type: ScamIndicatorType.courierFee,
          reasonIt: 'Chiede un piccolo pagamento per un pacco o una '
              'consegna, un classico pretesto per rubare i dati della '
              'carta.',
          reasonEn: 'It asks for a small payment for a package or delivery, '
              'a common pretext for stealing card details.',
        ),
      );
    }

    if (_prizeNotificationKeywords.any(lower.contains)) {
      matched.add(
        const ScamIndicator(
          type: ScamIndicatorType.prizeNotification,
          reasonIt: 'Annuncia una vincita o un premio inatteso.',
          reasonEn: 'It announces an unexpected prize or winnings.',
        ),
      );
    }

    final riskLevel = switch (matched.length) {
      0 => ScamRiskLevel.none,
      1 => ScamRiskLevel.low,
      _ => ScamRiskLevel.high,
    };

    return ScamAssessment(riskLevel: riskLevel, matchedIndicators: matched);
  }
}
