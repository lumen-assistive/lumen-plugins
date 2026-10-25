import 'package:meta/meta.dart';

import 'scam_risk_level.dart';

/// Which real, documented pattern a [ScamIndicator] matched.
enum ScamIndicatorType {
  /// Language pressuring the reader to act immediately.
  urgency,

  /// A request for a one-time code, PIN, or password.
  codeRequest,

  /// A shortened link hiding its real destination.
  shortUrl,

  /// Language impersonating a bank or its customer service.
  bankImpersonation,

  /// A courier redelivery or customs fee request, a common lure since
  /// it asks for a small, plausible payment rather than full account
  /// access.
  courierFee,

  /// A notification of an unexpected prize or winnings.
  prizeNotification,
}

/// One real, specific reason a message was flagged, rather than a
/// generic bucketed message: a reader can see exactly which phrase or
/// pattern triggered the flag.
@immutable
class ScamIndicator {
  /// Creates an indicator.
  const ScamIndicator({
    required this.type,
    required this.reasonIt,
    required this.reasonEn,
  });

  /// Which pattern this indicator represents.
  final ScamIndicatorType type;

  /// Plain-language reason, in Italian.
  final String reasonIt;

  /// Plain-language reason, in English.
  final String reasonEn;
}

/// The result of running [ScamFilter.assess] over a message.
///
/// Carries every indicator that matched, not just a count, so a user
/// sees specifically what was suspicious rather than one canned
/// paragraph that reads the same whether one thing matched or three.
@immutable
class ScamAssessment {
  /// Creates an assessment.
  const ScamAssessment({
    required this.riskLevel,
    required this.matchedIndicators,
  });

  /// How likely the assessed message is to be a scam.
  final ScamRiskLevel riskLevel;

  /// Every real indicator that matched, in the order they were checked.
  /// Empty when [riskLevel] is [ScamRiskLevel.none].
  final List<ScamIndicator> matchedIndicators;

  /// Every matched reason, in Italian, joined into one readable
  /// sentence, or a plain "nothing suspicious" message when
  /// [matchedIndicators] is empty.
  String get reasonIt => matchedIndicators.isEmpty
      ? 'Nessun elemento sospetto riconosciuto in questo messaggio.'
      : matchedIndicators.map((indicator) => indicator.reasonIt).join(' ');

  /// The English equivalent of [reasonIt].
  String get reasonEn => matchedIndicators.isEmpty
      ? 'No suspicious element recognized in this message.'
      : matchedIndicators.map((indicator) => indicator.reasonEn).join(' ');
}
