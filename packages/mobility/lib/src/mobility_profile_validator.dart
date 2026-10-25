import 'mobility_profile.dart';

/// Raised by [validateMobilityProfile] when a profile is incomplete.
class MobilityProfileValidationError implements Exception {
  /// Creates a validation error.
  const MobilityProfileValidationError(this.message);

  /// What is missing from the profile.
  final String message;

  @override
  String toString() => 'MobilityProfileValidationError: $message';
}

/// Validates [profile]. A [MobilityAidType.other] aid type must come
/// with a non-empty [MobilityProfile.notes] describing it, since
/// "other" on its own gives `lumen-app` nothing to show a caregiver or
/// to use when phrasing guidance.
///
/// Returns `null` if [profile] is valid, or a
/// [MobilityProfileValidationError] describing the problem.
MobilityProfileValidationError? validateMobilityProfile(
    MobilityProfile profile) {
  if (profile.aidType == MobilityAidType.other &&
      profile.notes.trim().isEmpty) {
    return const MobilityProfileValidationError(
      'A profile with aidType "other" must describe the aid in notes.',
    );
  }
  return null;
}
