import 'package:meta/meta.dart';

/// Emergency medical and contact information the SOS flow can draw on.
///
/// Lumen helps surface this information quickly but does not replace a
/// doctor or the emergency number; see the package README for the full
/// disclaimer.
@immutable
class EmergencyProfile {
  /// Creates a profile.
  const EmergencyProfile({
    required this.fullName,
    required this.emergencyContacts,
    this.medicalConditions = const [],
    this.medications = const [],
    this.bloodType,
  });

  /// The person's full name.
  final String fullName;

  /// Phone numbers to notify in an emergency, in priority order.
  final List<String> emergencyContacts;

  /// Known medical conditions relevant in an emergency.
  final List<String> medicalConditions;

  /// Medications relevant in an emergency, for example anticoagulants.
  final List<String> medications;

  /// Blood type, if known.
  final String? bloodType;
}
