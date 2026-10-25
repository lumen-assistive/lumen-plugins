import 'package:lumen_plugin_speech/lumen_plugin_speech.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('SpeechPlugin', () {
    late SpeechPlugin plugin;

    setUp(() async {
      plugin = SpeechPlugin();
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
