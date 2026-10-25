import 'emergency_profile.dart';

/// Raised by [validateEmergencyProfile] listing which required fields
/// are missing.
class EmergencyProfileValidationError implements Exception {
  /// Creates a validation error for the given [missingFields].
  const EmergencyProfileValidationError(this.missingFields);

  /// Names of the required fields that were missing or empty.
  final List<String> missingFields;

  @override
  String toString() => 'Missing required fields: ${missingFields.join(', ')}';
}

/// Validates that [profile] has the minimum information an SOS message
/// needs to be useful: a name and at least one emergency contact.
///
/// Returns `null` if [profile] is valid, or an
/// [EmergencyProfileValidationError] listing what is missing.
EmergencyProfileValidationError? validateEmergencyProfile(
  EmergencyProfile profile,
) {
  final missing = <String>[];
  if (profile.fullName.trim().isEmpty) missing.add('fullName');
  if (profile.emergencyContacts.isEmpty) missing.add('emergencyContacts');
  return missing.isEmpty ? null : EmergencyProfileValidationError(missing);
}
