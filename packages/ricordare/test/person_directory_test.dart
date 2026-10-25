import 'package:lumen_plugin_ricordare/lumen_plugin_ricordare.dart';
import 'package:test/test.dart';

void main() {
  group('PersonDirectory', () {
    test('stores and retrieves a profile without consent', () {
      final directory = PersonDirectory();

      directory.upsert(const PersonProfile(
          id: 'p1', name: 'Giulia', relationship: 'daughter'));

      expect(directory.byId('p1')!.name, 'Giulia');
    });

    test('stores a profile with consistent consent fields', () {
      final directory = PersonDirectory();

      directory.upsert(
        PersonProfile(
          id: 'p1',
          name: 'Giulia',
          relationship: 'daughter',
          consentGiven: true,
          consentTimestamp: DateTime(2026, 1, 1),
        ),
      );

      expect(directory.withConsent().map((p) => p.id), ['p1']);
    });

    test('rejects a profile marked consentGiven with no timestamp', () {
      final directory = PersonDirectory();

      expect(
        () => directory.upsert(
          const PersonProfile(
              id: 'p1',
              name: 'Giulia',
              relationship: 'daughter',
              consentGiven: true),
        ),
        throwsA(isA<PersonProfileConsentError>()),
      );
    });

    test('rejects a profile with a timestamp but consentGiven false', () {
      final directory = PersonDirectory();

      expect(
        () => directory.upsert(
          PersonProfile(
            id: 'p1',
            name: 'Giulia',
            relationship: 'daughter',
            consentTimestamp: DateTime(2026, 1, 1),
          ),
        ),
        throwsA(isA<PersonProfileConsentError>()),
      );
    });

    test('withConsent excludes profiles without consent', () {
      final directory = PersonDirectory();
      directory.upsert(const PersonProfile(
          id: 'p1', name: 'Giulia', relationship: 'daughter'));
      directory.upsert(
        PersonProfile(
          id: 'p2',
          name: 'Marco',
          relationship: 'son',
          consentGiven: true,
          consentTimestamp: DateTime(2026, 1, 1),
        ),
      );

      expect(directory.withConsent().map((p) => p.id), ['p2']);
    });

    test('remove deletes a profile', () {
      final directory = PersonDirectory();
      directory.upsert(const PersonProfile(
          id: 'p1', name: 'Giulia', relationship: 'daughter'));

      directory.remove('p1');

      expect(directory.byId('p1'), isNull);
    });
  });
}
