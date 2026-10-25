import 'package:lumen_sdk/lumen_sdk.dart';

import 'daily_status.dart';

/// Consent key gating whether this plugin is allowed to tell a paired
/// caregiver about the user's daily status.
const String shareStatusWithCaregiverConsentKey = 'share-status-with-caregiver';

/// Family module (Italian: Famiglia e caregiver).
///
/// Provides the local business logic for caregiver pairing, the shared
/// calendar, and daily status. Actual delivery to a caregiver's own
/// device (push notifications, `lumen-server` sync) is not implemented
/// here; see the package README for current scope.
class FamilyPlugin implements LumenPlugin {
  late PluginContext _context;

  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'family',
    nameIt: 'Famiglia',
    nameEn: 'Family',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [],
  );

  @override
  Future<void> initialize(PluginContext context) async {
    _context = context;
  }

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}

  /// Publishes an [AlertEvent] telling a paired caregiver about today's
  /// status, but only if the user has granted
  /// [shareStatusWithCaregiverConsentKey]. Does nothing otherwise.
  void notifyCaregiverOfStatus(DailyStatusValue value) {
    if (!_context.hasConsent(shareStatusWithCaregiverConsentKey)) {
      return;
    }

    _context.eventBus.publish(
      AlertEvent(
        timestamp: DateTime.now(),
        pluginId: manifest.id,
        severity: value == DailyStatusValue.needsAttention
            ? AlertSeverity.warning
            : AlertSeverity.info,
        messageIt: _messageIt(value),
        messageEn: _messageEn(value),
      ),
    );
  }

  String _messageIt(DailyStatusValue value) {
    switch (value) {
      case DailyStatusValue.ok:
        return 'Oggi va tutto bene.';
      case DailyStatusValue.needsAttention:
        return 'Oggi potrebbe servire attenzione.';
      case DailyStatusValue.unknown:
        return 'Stato di oggi non ancora impostato.';
    }
  }

  String _messageEn(DailyStatusValue value) {
    switch (value) {
      case DailyStatusValue.ok:
        return 'Everything is fine today.';
      case DailyStatusValue.needsAttention:
        return 'Today might need attention.';
      case DailyStatusValue.unknown:
        return "Today's status has not been set yet.";
    }
  }
}
