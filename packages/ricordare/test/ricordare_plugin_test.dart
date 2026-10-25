import 'package:lumen_plugin_ricordare/lumen_plugin_ricordare.dart';
import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:lumen_sdk/lumen_sdk_testing.dart';
import 'package:test/test.dart';

void main() {
  group('RicordarePlugin', () {
    late RicordarePlugin plugin;
    late FakePluginContext context;

    setUp(() async {
      plugin = RicordarePlugin(
          reminderScheduler:
              ReminderScheduler(now: () => DateTime(2026, 1, 1)));
      context = FakePluginContext();
      await plugin.initialize(context);
    });

    tearDown(() async {
      await plugin.dispose();
    });

    test('declares no capabilities', () {
      expect(plugin.manifest.capabilities, isEmpty);
    });

    test('checkDueReminders publishes an alert for each due reminder',
        () async {
      plugin.reminderScheduler.add(
        Reminder(
            id: 'r1', title: 'Take medication', dueAt: DateTime(2026, 1, 1)),
      );

      final nextAlert = context.eventBus.on<AlertEvent>().first;
      plugin.checkDueReminders();

      final alert = await nextAlert;
      expect(alert.pluginId, 'ricordare');
      expect(alert.messageEn, contains('Take medication'));
    });

    test('checkDueReminders marks handled reminders so they are not repeated',
        () async {
      plugin.reminderScheduler.add(
        Reminder(id: 'r1', title: 'Dentist', dueAt: DateTime(2026, 1, 1)),
      );

      var alertCount = 0;
      context.eventBus.on<AlertEvent>().listen((_) => alertCount++);

      plugin.checkDueReminders();
      await Future<void>.delayed(Duration.zero);
      plugin.checkDueReminders();
      await Future<void>.delayed(Duration.zero);

      expect(alertCount, 1);
    });
  });
}
