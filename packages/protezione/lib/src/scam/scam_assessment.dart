import 'package:meta/meta.dart';

import 'scam_risk_level.dart';

/// The result of running [ScamFilter.assess] over a message.
///
/// Carries a plain-language reason in both of the app's locales so a
/// user is never told a message is risky without being told why.
@immutable
class ScamAssessment {
  /// Creates an assessment.
  const ScamAssessment({
    required this.riskLevel,
    required this.reasonIt,
    required this.reasonEn,
  });

  /// How likely the assessed message is to be a scam.
  final ScamRiskLevel riskLevel;

  /// Plain-language reason, in Italian.
  final String reasonIt;

  /// Plain-language reason, in English.
  final String reasonEn;
}
