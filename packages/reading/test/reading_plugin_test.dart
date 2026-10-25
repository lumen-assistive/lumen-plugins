import 'package:lumen_plugin_reading/lumen_plugin_reading.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('ReadingPlugin', () {
    late ReadingPlugin plugin;

    setUp(() async {
      plugin = ReadingPlugin();
      await plugin.initialize(FakePluginContext());
    });

    tearDown(() async {
      await plugin.dispose();
    });

    test('declares no capabilities', () {
      expect(plugin.manifest.capabilities, isEmpty);
    });

    test('exposes a working syllable splitter', () {
      expect(plugin.syllableSplitter.split('casa'), ['ca', 'sa']);
    });

    test('exposes an empty flashcard deck by default', () {
      expect(plugin.flashcardDeck.all(), isEmpty);
    });
  });
}
