import 'package:lumen_sdk/lumen_sdk.dart';

import 'person/person_directory.dart';
import 'reminder/reminder_scheduler.dart';

/// Lumen's Ricordare (Remember) module: a consent-gated person
/// directory and recurring reminders.
///
/// `lumen_sdk` has no "directory changed" or "timer fired" event type,
/// so this plugin exposes [personDirectory] and [reminderScheduler]
/// directly through getters, the same pattern `FamigliaPlugin` uses for
/// its calendar and status stores.
class RicordarePlugin implements LumenPlugin {
  /// Creates the plugin, optionally with a custom [personDirectory] or
  /// [reminderScheduler] for testing.
  RicordarePlugin(
      {PersonDirectory? personDirectory, ReminderScheduler? reminderScheduler})
      : _personDirectory = personDirectory ?? PersonDirectory(),
        _reminderScheduler = reminderScheduler ?? ReminderScheduler();

  final PersonDirectory _personDirectory;
  final ReminderScheduler _reminderScheduler;

  late PluginContext _context;

  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'ricordare',
    nameIt: 'Ricordare',
    nameEn: 'Remember',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [],
  );

  /// The directory of people Lumen's user has recorded.
  PersonDirectory get personDirectory => _personDirectory;

  /// The user's reminders.
  ReminderScheduler get reminderScheduler => _reminderScheduler;

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

  /// Publishes an [AlertEvent] for every reminder currently due, then
  /// marks each handled so it is not reported again until its next
  /// occurrence, if it recurs.
  ///
  /// `lumen_sdk` has no scheduled-timer event type to drive this
  /// automatically yet, so `lumen-app` is expected to call this
  /// periodically.
  void checkDueReminders() {
    for (final reminder in _reminderScheduler.dueReminders()) {
      _context.eventBus.publish(
        AlertEvent(
          timestamp: DateTime.now(),
          pluginId: manifest.id,
          severity: AlertSeverity.info,
          messageIt: 'Promemoria: ${reminder.title}',
          messageEn: 'Reminder: ${reminder.title}',
        ),
      );
      _reminderScheduler.markHandled(reminder.id);
    }
  }
}
