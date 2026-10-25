import 'package:lumen_plugin_hearing/lumen_plugin_hearing.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('AlertPresentationMapper', () {
    final mapper = AlertPresentationMapper();

    test('maps smoke_alarm to a critical, flashing presentation', () {
      final presentation = mapper.presentationFor('smoke_alarm');
      expect(presentation.severity, AlertSeverity.critical);
      expect(presentation.useFlash, isTrue);
      expect(presentation.vibrationPatternMs, isNotEmpty);
    });

    test('maps doorbell to a non-critical, non-flashing presentation', () {
      final presentation = mapper.presentationFor('doorbell');
      expect(presentation.severity, AlertSeverity.info);
      expect(presentation.useFlash, isFalse);
    });

    test('falls back to a conservative presentation for unknown labels', () {
      final presentation = mapper.presentationFor('unknown_sound');
      expect(presentation.severity, AlertSeverity.info);
      expect(presentation.useFlash, isFalse);
      expect(presentation.vibrationPatternMs, isNotEmpty);
    });
  });
}
