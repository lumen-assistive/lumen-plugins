import 'person_profile.dart';
import 'person_profile_validator.dart';

/// Stores the [PersonProfile]s Lumen's user has recorded, enforcing the
/// consent invariant [validatePersonProfile] checks on every write.
class PersonDirectory {
  final Map<String, PersonProfile> _profiles = {};

  /// Adds [profile], or replaces the existing profile with the same
  /// [PersonProfile.id] if there is one.
  ///
  /// Throws [PersonProfileConsentError] if [profile]'s consent fields
  /// are inconsistent, rather than storing a profile whose consent
  /// state cannot be trusted later.
  void upsert(PersonProfile profile) {
    final error = validatePersonProfile(profile);
    if (error != null) {
      throw error;
    }
    _profiles[profile.id] = profile;
  }

  /// Removes the profile with [id], if one exists.
  void remove(String id) {
    _profiles.remove(id);
  }

  /// The profile with [id], or `null` if there is none.
  PersonProfile? byId(String id) => _profiles[id];

  /// Every profile in the directory.
  List<PersonProfile> all() => _profiles.values.toList(growable: false);

  /// Profiles that have given consent: the only ones that would ever be
  /// eligible for on-device recognition once that capability exists.
  List<PersonProfile> withConsent() => _profiles.values
      .where((profile) => profile.consentGiven)
      .toList(growable: false);
}
