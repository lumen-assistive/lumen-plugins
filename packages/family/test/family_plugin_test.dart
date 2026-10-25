import 'package:lumen_plugin_family/lumen_plugin_family.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('FamilyPlugin', () {
    test('publishes an alert when consent is granted', () async {
      final context = FakePluginContext(
        grantedConsents: {shareStatusWithCaregiverConsentKey},
      );
      final plugin = FamilyPlugin();
      await plugin.initialize(context);

      final nextAlert = context.eventBus.on<AlertEvent>().first;
      plugin.notifyCaregiverOfStatus(DailyStatusValue.needsAttention);

      final alert = await nextAlert;
      expect(alert.pluginId, 'family');
      expect(alert.severity, AlertSeverity.warning);
    });

    test('does not publish anything without consent', () async {
      final context = FakePluginContext();
      final plugin = FamilyPlugin();
      await plugin.initialize(context);

      var alertCount = 0;
      context.eventBus.on<AlertEvent>().listen((_) => alertCount++);

      plugin.notifyCaregiverOfStatus(DailyStatusValue.ok);
      await Future<void>.delayed(Duration.zero);

      expect(alertCount, 0);
    });
  });
}
