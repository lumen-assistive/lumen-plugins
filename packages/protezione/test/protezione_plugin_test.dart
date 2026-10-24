import 'package:lumen_plugin_protezione/lumen_plugin_protezione.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('ProtezionePlugin', () {
    test('declares the expected manifest', () {
      final plugin = ProtezionePlugin();

      expect(plugin.manifest.id, 'protezione');
      expect(plugin.manifest.capabilities, [
        PluginCapability.location,
        PluginCapability.smsSend,
        PluginCapability.smsRead,
        PluginCapability.notifications,
      ]);
    });

    test('completes the full lifecycle without error', () async {
      final plugin = ProtezionePlugin();
      final context = FakePluginContext();

      await plugin.initialize(context);
      await plugin.start();
      await plugin.stop();
      await plugin.dispose();
    });
  });
}
