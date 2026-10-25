import 'package:lumen_plugin_safety/lumen_plugin_safety.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('SafetyPlugin', () {
    test('declares the expected manifest', () {
      final plugin = SafetyPlugin();

      expect(plugin.manifest.id, 'safety');
      expect(plugin.manifest.capabilities, [
        PluginCapability.location,
        PluginCapability.smsSend,
        PluginCapability.smsRead,
        PluginCapability.notifications,
      ]);
    });

    test('completes the full lifecycle without error', () async {
      final plugin = SafetyPlugin();
      final context = FakePluginContext();

      await plugin.initialize(context);
      await plugin.start();
      await plugin.stop();
      await plugin.dispose();
    });
  });
}
