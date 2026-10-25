import 'package:lumen_plugin_mobility/lumen_plugin_mobility.dart';
import 'package:test/test.dart';

void main() {
  group('validateMobilityProfile', () {
    test('accepts a profile with aidType none', () {
      const profile = MobilityProfile(aidType: MobilityAidType.none);

      expect(validateMobilityProfile(profile), isNull);
    });

    test('accepts a profile with aidType other when notes describe it', () {
      const profile = MobilityProfile(
          aidType: MobilityAidType.other, notes: 'Forearm crutches');

      expect(validateMobilityProfile(profile), isNull);
    });

    test('rejects a profile with aidType other and empty notes', () {
      const profile = MobilityProfile(aidType: MobilityAidType.other);

      expect(validateMobilityProfile(profile),
          isA<MobilityProfileValidationError>());
    });

    test('rejects a profile with aidType other and whitespace-only notes', () {
      const profile =
          MobilityProfile(aidType: MobilityAidType.other, notes: '   ');

      expect(validateMobilityProfile(profile),
          isA<MobilityProfileValidationError>());
    });
  });
}
