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

  static final RegExp _shortUrlPattern = RegExp(
    r'https?://(bit\.ly|tinyurl\.com|t\.co|goo\.gl)/\S+',
    caseSensitive: false,
  );

  /// Assesses [text], the body of an incoming SMS or message.
  ScamAssessment assess(String text) {
    final lower = text.toLowerCase();

    final hasUrgency = _urgencyKeywords.any(lower.contains);
    final hasCodeRequest = _codeRequestKeywords.any(lower.contains);
    final hasShortUrl = _shortUrlPattern.hasMatch(text);

    final suspiciousCount =
        (hasUrgency ? 1 : 0) + (hasCodeRequest ? 1 : 0) + (hasShortUrl ? 1 : 0);

    if (suspiciousCount >= 2) {
      return const ScamAssessment(
        riskLevel: ScamRiskLevel.high,
        reasonIt: 'Il messaggio combina più segnali tipici delle truffe, come '
            'richieste di codici o password insieme a un tono urgente o '
            'a un link abbreviato.',
        reasonEn: 'The message combines multiple signals typical of scams, '
            'such as a request for a code or password together with '
            'urgent language or a shortened link.',
      );
    }

    if (suspiciousCount == 1) {
      return const ScamAssessment(
        riskLevel: ScamRiskLevel.low,
        reasonIt: 'Il messaggio contiene un elemento a volte presente nei '
            'messaggi truffa, come urgenza, richiesta di codici o un '
            'link abbreviato. Verifica con cautela prima di rispondere.',
        reasonEn: 'The message contains something sometimes found in scam '
            'messages, such as urgency, a code request, or a shortened '
            'link. Treat it with caution before replying.',
      );
    }

    return const ScamAssessment(
      riskLevel: ScamRiskLevel.none,
      reasonIt: 'Nessun elemento sospetto riconosciuto in questo messaggio.',
      reasonEn: 'No suspicious element recognized in this message.',
    );
  }
}
