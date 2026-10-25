import 'package:meta/meta.dart';

/// The kind of mobility aid, if any, Lumen's user relies on.
enum MobilityAidType {
  /// No mobility aid.
  none,

  /// A cane or walking stick.
  cane,

  /// A wheelchair.
  wheelchair,

  /// A walker or rollator.
  walker,

  /// Something not covered above, described in
  /// [MobilityProfile.notes].
  other,
}

/// How much detail guidance should include.
enum GuidanceVerbosity {
  /// Short, essential guidance only.
  minimal,

  /// The default amount of detail.
  standard,

  /// Full detail, for someone who wants every relevant cue spelled out.
  detailed,
}

/// How Lumen's user gets around, and how much detail they want from
/// movement-related guidance.
@immutable
class MobilityProfile {
  /// Creates a profile.
  const MobilityProfile({
    required this.aidType,
    this.guidanceVerbosity = GuidanceVerbosity.standard,
    this.notes = '',
  });

  /// The kind of mobility aid in use, if any.
  final MobilityAidType aidType;

  /// How much detail guidance should include.
  final GuidanceVerbosity guidanceVerbosity;

  /// Free-form notes, required when [aidType] is [MobilityAidType.other];
  /// see [validateMobilityProfile].
  final String notes;
}
