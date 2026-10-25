import 'package:lumen_plugin_muoversi/lumen_plugin_muoversi.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('MuoversiPlugin', () {
    late MuoversiPlugin plugin;

    setUp(() async {
      plugin = MuoversiPlugin();
      await plugin.initialize(FakePluginContext());
    });

    tearDown(() async {
      await plugin.dispose();
    });

    test('declares no capabilities', () {
      expect(plugin.manifest.capabilities, isEmpty);
    });

    test('exposes a working gait stability monitor', () {
      final result = plugin.gaitStabilityMonitor.analyze(const []);

      expect(result.stepCount, 0);
    });

    test('start and stop are no-ops that complete without error', () async {
      await plugin.start();
      await plugin.stop();
    });
  });
}
