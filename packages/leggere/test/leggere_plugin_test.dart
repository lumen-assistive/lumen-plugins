import 'package:lumen_plugin_leggere/lumen_plugin_leggere.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('LeggerePlugin', () {
    late LeggerePlugin plugin;

    setUp(() async {
      plugin = LeggerePlugin();
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
