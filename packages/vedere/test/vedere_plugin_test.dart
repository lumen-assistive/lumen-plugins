import 'package:lumen_plugin_vedere/lumen_plugin_vedere.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('VederePlugin', () {
    late VederePlugin plugin;
    late FakePluginContext context;

    setUp(() async {
      plugin = VederePlugin();
      context = FakePluginContext();
      await plugin.initialize(context);
    });

    tearDown(() async {
      await plugin.dispose();
    });

    test('declares the camera capability', () {
      expect(plugin.manifest.capabilities, [PluginCapability.camera]);
    });

    test('publishes an alert when an expiry date is recognized', () async {
      await plugin.start();

      final nextAlert = context.eventBus.on<AlertEvent>().first;
      context.eventBus.publish(
        OcrResultEvent(
          timestamp: DateTime(2026),
          text: 'Scadenza: 25/12/2026',
          confidence: 0.95,
        ),
      );

      final alert = await nextAlert;
      expect(alert.pluginId, 'vedere');
      expect(alert.severity, AlertSeverity.info);
      expect(alert.messageIt, contains('25/12/2026'));
      expect(alert.messageEn, contains('2026-12-25'));
    });

    test('publishes nothing when no expiry date is found', () async {
      await plugin.start();

      var alertCount = 0;
      context.eventBus.on<AlertEvent>().listen((_) => alertCount++);

      context.eventBus.publish(
        OcrResultEvent(
          timestamp: DateTime(2026),
          text: 'Ingredienti: farina, acqua, sale',
          confidence: 0.9,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(alertCount, 0);
    });

    test('stops delivering alerts after stop', () async {
      await plugin.start();
      await plugin.stop();

      var alertCount = 0;
      context.eventBus.on<AlertEvent>().listen((_) => alertCount++);

      context.eventBus.publish(
        OcrResultEvent(
          timestamp: DateTime(2026),
          text: 'Scadenza: 25/12/2026',
          confidence: 0.95,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(alertCount, 0);
    });
  });
}
