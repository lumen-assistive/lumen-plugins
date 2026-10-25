import 'package:lumen_plugin_parlare/lumen_plugin_parlare.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('ParlarePlugin', () {
    late ParlarePlugin plugin;

    setUp(() async {
      plugin = ParlarePlugin();
      await plugin.initialize(FakePluginContext());
    });

    tearDown(() async {
      await plugin.dispose();
    });

    test('exposes a non-empty default board', () {
      expect(plugin.board.all(), isNotEmpty);
    });

    test('declares no capabilities', () {
      expect(plugin.manifest.capabilities, isEmpty);
    });

    test('selectPhrase records usage on the tracker', () {
      plugin.selectPhrase('needs-water');

      expect(plugin.usageTracker.topSuggestions(), contains('needs-water'));
    });
  });
}
