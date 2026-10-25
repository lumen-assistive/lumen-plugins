import 'package:meta/meta.dart';

import 'caregiver_role.dart';

/// A pairing between a caregiver and the device they are helping to
/// watch over.
@immutable
class CaregiverLink {
  /// Creates a caregiver link.
  const CaregiverLink({
    required this.caregiverId,
    required this.pairedDeviceId,
    required this.role,
    required this.pairedAt,
  });

  /// Identifier of the caregiver account, assigned by `lumen-server`.
  final String caregiverId;

  /// Identifier of the device that was paired with this caregiver.
  final String pairedDeviceId;

  /// What this caregiver is allowed to do once paired.
  final CaregiverRole role;

  /// When this pairing was established.
  final DateTime pairedAt;
}
