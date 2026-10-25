import 'package:lumen_sdk/lumen_sdk.dart';

import 'gait/gait_stability_monitor.dart';

/// Lumen's Muoversi (Move) module: proactive gait stability monitoring.
///
/// `lumen_sdk` does not yet define a raw accelerometer event, so there
/// is nothing on the event bus for this plugin to subscribe to yet:
/// [start] and [stop] are no-ops, the same limitation documented on
/// `lumen_plugin_protezione`'s `ProtezionePlugin`. [gaitStabilityMonitor]
/// is fully implemented and tested and ready to be wired to that event
/// once it exists.
class MuoversiPlugin implements LumenPlugin {
  /// Creates the plugin, optionally with a custom [gaitStabilityMonitor]
  /// for testing.
  MuoversiPlugin({GaitStabilityMonitor? gaitStabilityMonitor})
      : _gaitStabilityMonitor =
            gaitStabilityMonitor ?? const GaitStabilityMonitor();

  final GaitStabilityMonitor _gaitStabilityMonitor;

  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'muoversi',
    nameIt: 'Muoversi',
    nameEn: 'Move',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [],
  );

  /// The gait stability analysis this plugin wraps. Exposed directly so
  /// a host app can feed it accelerometer samples from wherever it
  /// reads them today.
  GaitStabilityMonitor get gaitStabilityMonitor => _gaitStabilityMonitor;

  @override
  Future<void> initialize(PluginContext context) async {}

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
