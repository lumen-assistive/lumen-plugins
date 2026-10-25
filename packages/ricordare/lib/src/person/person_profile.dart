import 'package:meta/meta.dart';

/// Information about a person Lumen's user may want help remembering.
///
/// `lumen-core` has no on-device face recognition model or camera
/// bridge yet (see the package README), so nothing can currently use
/// [consentGiven] for actual recognition. The field exists so the
/// consent record itself can be captured and managed ahead of that
/// wiring, consistent with the project's privacy commitment that
/// recognition will only ever run on-device with explicit consent.
@immutable
class PersonProfile {
  /// Creates a profile.
  const PersonProfile({
    required this.id,
    required this.name,
    required this.relationship,
    this.notes = '',
    this.consentGiven = false,
    this.consentTimestamp,
  });

  /// Stable, unique identifier.
  final String id;

  /// The person's name, as Lumen's user refers to them.
  final String name;

  /// How this person relates to Lumen's user, for example "daughter" or
  /// "neighbor".
  final String relationship;

  /// Free-form notes to help recall this person, for example
  /// distinguishing details or shared memories.
  final String notes;

  /// Whether this person has consented to being recognized by a future
  /// on-device recognition feature. Must agree with [consentTimestamp]
  /// being set; see [validatePersonProfile].
  final bool consentGiven;

  /// When [consentGiven] was recorded, or `null` if consent has not
  /// been given.
  final DateTime? consentTimestamp;

  /// Returns a copy of this profile with the given fields replaced.
  PersonProfile copyWith({
    String? name,
    String? relationship,
    String? notes,
    bool? consentGiven,
    DateTime? consentTimestamp,
  }) {
    return PersonProfile(
      id: id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      notes: notes ?? this.notes,
      consentGiven: consentGiven ?? this.consentGiven,
      consentTimestamp: consentTimestamp ?? this.consentTimestamp,
    );
  }
}
