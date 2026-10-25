import 'dart:math';

import 'package:lumen_plugin_family/lumen_plugin_family.dart';
import 'package:test/test.dart';

void main() {
  group('PairingCodeGenerator', () {
    test('generates a six-digit zero-padded code', () {
      final generator = PairingCodeGenerator(random: Random(1));
      final now = DateTime(2026, 1, 1);

      final code = generator.generate(now: now);

      expect(code.code.length, 6);
      expect(int.tryParse(code.code), isNotNull);
    });

    test('expires after the configured validity window', () {
      final generator = PairingCodeGenerator(
        random: Random(1),
        validity: const Duration(minutes: 5),
      );
      final now = DateTime(2026, 1, 1, 12);

      final code = generator.generate(now: now);

      expect(code.expiresAt, now.add(const Duration(minutes: 5)));
    });

    test('validate accepts a matching, unexpired code', () {
      final generator = PairingCodeGenerator(random: Random(1));
      final now = DateTime(2026, 1, 1);
      final code = generator.generate(now: now);

      final isValid = generator.validate(
        issued: code,
        submittedCode: code.code,
        now: now.add(const Duration(minutes: 1)),
      );

      expect(isValid, isTrue);
    });

    test('validate rejects a mismatched code', () {
      final generator = PairingCodeGenerator(random: Random(1));
      final now = DateTime(2026, 1, 1);
      final code = generator.generate(now: now);

      final isValid = generator.validate(
        issued: code,
        submittedCode: '000000' == code.code ? '111111' : '000000',
        now: now,
      );

      expect(isValid, isFalse);
    });

    test('validate rejects an expired code', () {
      final generator = PairingCodeGenerator(
        random: Random(1),
        validity: const Duration(minutes: 10),
      );
      final now = DateTime(2026, 1, 1);
      final code = generator.generate(now: now);

      final isValid = generator.validate(
        issued: code,
        submittedCode: code.code,
        now: now.add(const Duration(minutes: 11)),
      );

      expect(isValid, isFalse);
    });
  });
}
