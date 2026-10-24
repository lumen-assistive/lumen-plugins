/// How likely a message is to be a scam, per [ScamFilter].
enum ScamRiskLevel {
  /// No suspicious element recognized.
  none,

  /// One suspicious element recognized; worth a second look.
  low,

  /// Multiple suspicious elements recognized together.
  high,
}
