import 'package:lumen_plugin_famiglia/lumen_plugin_famiglia.dart';
import 'package:test/test.dart';

void main() {
  group('DailyStatusTracker', () {
    test('reports unknown before any status is set', () {
      final tracker = DailyStatusTracker(now: () => DateTime(2026, 1, 1));

      expect(tracker.statusForToday(), DailyStatusValue.unknown);
    });

    test('reports the status set earlier the same day', () {
      final tracker = DailyStatusTracker(now: () => DateTime(2026, 1, 1, 9));

      tracker.setToday(DailyStatusValue.ok);

      expect(tracker.statusForToday(), DailyStatusValue.ok);
    });

    test('resets to unknown once the day rolls over', () {
      var now = DateTime(2026, 1, 1, 9);
      final tracker = DailyStatusTracker(now: () => now);

      tracker.setToday(DailyStatusValue.needsAttention);
      expect(tracker.statusForToday(), DailyStatusValue.needsAttention);

      now = DateTime(2026, 1, 2, 9);
      expect(tracker.statusForToday(), DailyStatusValue.unknown);
    });
  });

  group('caregiver permissions', () {
    test('viewer can view and receive alerts but not modify config', () {
      expect(
        caregiverRoleAllows(CaregiverRole.viewer, CaregiverAction.viewCalendar),
        isTrue,
      );
      expect(
        caregiverRoleAllows(
          CaregiverRole.viewer,
          CaregiverAction.receiveAlerts,
        ),
        isTrue,
      );
      expect(
        caregiverRoleAllows(CaregiverRole.viewer, CaregiverAction.modifyConfig),
        isFalse,
      );
    });

    test('manager can do everything a viewer can plus modify config', () {
      for (final action in CaregiverAction.values) {
        expect(caregiverRoleAllows(CaregiverRole.manager, action), isTrue);
      }
    });
  });
}
