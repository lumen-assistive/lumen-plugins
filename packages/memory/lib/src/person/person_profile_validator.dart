import 'person_profile.dart';

/// Raised by [validatePersonProfile] when a profile's consent fields
/// are inconsistent.
class PersonProfileConsentError implements Exception {
  /// Creates a consent validation error.
  const PersonProfileConsentError(this.message);

  /// What is inconsistent about the profile.
  final String message;

  @override
  String toString() => 'PersonProfileConsentError: $message';
}

/// Validates that [profile]'s consent fields are internally consistent:
/// [PersonProfile.consentGiven] can only be true when
/// [PersonProfile.consentTimestamp] is set, and a timestamp only makes
/// sense alongside consent having been given. This keeps the consent
/// record itself honest even before any feature acts on it.
///
/// Returns `null` if [profile] is valid, or a
/// [PersonProfileConsentError] describing the inconsistency.
PersonProfileConsentError? validatePersonProfile(PersonProfile profile) {
  if (profile.consentGiven && profile.consentTimestamp == null) {
    return const PersonProfileConsentError(
      'A profile with consentGiven set to true must have a consentTimestamp.',
    );
  }
  if (!profile.consentGiven && profile.consentTimestamp != null) {
    return const PersonProfileConsentError(
      'A profile with a consentTimestamp must have consentGiven set to true.',
    );
  }
  return null;
}
