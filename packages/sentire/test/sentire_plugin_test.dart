import 'package:lumen_plugin_sentire/lumen_plugin_sentire.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('SentirePlugin', () {
    late SentirePlugin plugin;
    late FakePluginContext context;

    setUp(() async {
      plugin = SentirePlugin();
      context = FakePluginContext();
      await plugin.initialize(context);
    });

    tearDown(() async {
      await plugin.dispose();
    });

    test('declares the microphone capability', () {
      expect(plugin.manifest.capabilities, [PluginCapability.microphone]);
    });

    test('opens a session on start and accumulates final transcripts',
        () async {
      await plugin.start();

      context.eventBus.publish(
        TranscriptEvent(timestamp: DateTime(2026), text: 'Ciao', isFinal: true),
      );
      context.eventBus.publish(
        TranscriptEvent(
            timestamp: DateTime(2026), text: 'bozza', isFinal: false),
      );
      await Future<void>.delayed(Duration.zero);

      final summary = plugin.currentSession!.close(endedAt: DateTime(2026));
      expect(summary.text, 'Ciao');
    });

    test('publishes an alert when a sound alert arrives', () async {
      await plugin.start();

      final nextAlert = context.eventBus.on<AlertEvent>().first;
      context.eventBus.publish(
        SoundAlertEvent(
          timestamp: DateTime(2026),
          label: 'smoke_alarm',
          confidence: 0.95,
        ),
      );

      final alert = await nextAlert;
      expect(alert.pluginId, 'sentire');
      expect(alert.severity, AlertSeverity.critical);
    });

    test('clears the session on stop', () async {
      await plugin.start();
      await plugin.stop();

      expect(plugin.currentSession, isNull);
    });
  });
}
