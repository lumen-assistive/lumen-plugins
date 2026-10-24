import 'dart:math';

/// A freshly generated pairing code and when it stops being valid.
class PairingCode {
  /// Creates a pairing code result.
  const PairingCode({required this.code, required this.expiresAt});

  /// Six-digit numeric code, zero-padded, for example `"042918"`.
  final String code;

  /// When this code can no longer be redeemed.
  final DateTime expiresAt;
}

/// Generates and validates short-lived pairing codes caregivers enter
/// to link their account to a user's device.
///
/// A new instance should be created per pairing attempt; this class
/// holds no state beyond the random source, so a single instance may
/// also be reused safely across attempts.
class PairingCodeGenerator {
  /// Creates a generator. [random] defaults to a cryptographically
  /// secure source; pass a seeded [Random] only in tests that need
  /// deterministic output.
  PairingCodeGenerator({
    Random? random,
    this.validity = const Duration(minutes: 10),
  }) : _random = random ?? Random.secure();

  final Random _random;

  /// How long a generated code remains valid.
  final Duration validity;

  /// Generates a new six-digit pairing code valid from [now] for
  /// [validity].
  PairingCode generate({required DateTime now}) {
    final value = _random.nextInt(1000000);
    final code = value.toString().padLeft(6, '0');
    return PairingCode(code: code, expiresAt: now.add(validity));
  }

  /// Whether [submittedCode] matches [issued] and [issued] has not
  /// expired as of [now].
  bool validate({
    required PairingCode issued,
    required String submittedCode,
    required DateTime now,
  }) {
    if (submittedCode != issued.code) return false;
    return now.isBefore(issued.expiresAt);
  }
}
