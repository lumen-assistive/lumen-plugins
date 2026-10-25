import 'package:lumen_sdk/lumen_sdk.dart';

import 'phrase_board.dart';
import 'phrase_usage_tracker.dart';

/// Lumen's Parlare (Speak) module: an augmentative communication phrase
/// board with usage-ranked suggestions.
///
/// `lumen_sdk` has no "phrase selected" event type, so this plugin
/// exposes [board] and [usageTracker] directly through getters instead
/// of only through the event bus, the same pattern `FamigliaPlugin`
/// uses for its calendar and status stores. `lumen-app` is expected to
/// read these directly to render the board and call [selectPhrase] when
/// the person picks one.
class ParlarePlugin implements LumenPlugin {
  /// Creates the plugin, optionally with a custom [board] or
  /// [usageTracker] for testing.
  ParlarePlugin({PhraseBoard? board, PhraseUsageTracker? usageTracker})
      : _board = board ?? PhraseBoard(),
        _usageTracker = usageTracker ?? PhraseUsageTracker();

  final PhraseBoard _board;
  final PhraseUsageTracker _usageTracker;

  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'parlare',
    nameIt: 'Parlare',
    nameEn: 'Speak',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [],
  );

  /// The board of quick phrases this plugin manages.
  PhraseBoard get board => _board;

  /// Tracks phrase usage to rank suggestions.
  PhraseUsageTracker get usageTracker => _usageTracker;

  /// Records that the phrase with [phraseId] was spoken or selected, so
  /// future suggestion rankings reflect it.
  void selectPhrase(String phraseId) {
    _usageTracker.recordUse(phraseId);
  }

  @override
  Future<void> initialize(PluginContext context) async {}

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
