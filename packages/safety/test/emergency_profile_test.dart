import 'package:lumen_plugin_safety/lumen_plugin_safety.dart';
import 'package:test/test.dart';

void main() {
  group('validateEmergencyProfile', () {
    test('accepts a profile with a name and at least one contact', () {
      const profile = EmergencyProfile(
        fullName: 'Maria Rossi',
        emergencyContacts: ['+390000000000'],
      );

      expect(validateEmergencyProfile(profile), isNull);
    });

    test('rejects a profile with an empty name', () {
      const profile = EmergencyProfile(
        fullName: '   ',
        emergencyContacts: ['+390000000000'],
      );

      final error = validateEmergencyProfile(profile);

      expect(error, isNotNull);
      expect(error!.missingFields, contains('fullName'));
    });

    test('rejects a profile with no emergency contacts', () {
      const profile = EmergencyProfile(
        fullName: 'Maria Rossi',
        emergencyContacts: [],
      );

      final error = validateEmergencyProfile(profile);

      expect(error, isNotNull);
      expect(error!.missingFields, contains('emergencyContacts'));
    });

    test('reports both fields missing at once', () {
      const profile = EmergencyProfile(fullName: '', emergencyContacts: []);

      final error = validateEmergencyProfile(profile);

      expect(error!.missingFields, ['fullName', 'emergencyContacts']);
    });

    test('toString includes the missing field names', () {
      const error = EmergencyProfileValidationError(['fullName']);

      expect(error.toString(), contains('fullName'));
    });
  });
}
