import 'package:lumen_sdk/lumen_sdk.dart';

/// Lumen Safety module (Italian: Protezione).
///
/// `lumen_sdk` does not yet define raw accelerometer or incoming-SMS
/// events, so there is nothing on the event bus for this plugin to
/// subscribe to yet: [start] and [stop] are no-ops. The module's actual
/// logic, `FallDetector`, `SosController`, `ScamFilter`, and
/// `EmergencyProfile` validation, is fully implemented and tested and
/// ready to be wired to those events once they exist; see the package
/// README for the tracked next step.
class SafetyPlugin implements LumenPlugin {
  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'safety',
    nameIt: 'Protezione',
    nameEn: 'Safety',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [
      PluginCapability.location,
      PluginCapability.smsSend,
      PluginCapability.smsRead,
      PluginCapability.notifications,
    ],
  );

  @override
  Future<void> initialize(PluginContext context) async {}

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
