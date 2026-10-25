import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:meta/meta.dart';

/// How `lumen-app` should present a sound alert to the user: a
/// vibration pattern, whether to also flash the screen or camera
/// flash, and a severity for ordering competing alerts.
///
/// This package only computes the presentation; `lumen-app` is
/// responsible for actually triggering haptics and the flash through
/// the platform APIs.
@immutable
class AlertPresentation {
  /// Creates an alert presentation.
  const AlertPresentation({
    required this.vibrationPatternMs,
    required this.useFlash,
    required this.severity,
  });

  /// Alternating vibrate/pause durations in milliseconds, starting with
  /// a vibration, for example `[200, 100, 200]` means vibrate 200ms,
  /// pause 100ms, vibrate 200ms.
  final List<int> vibrationPatternMs;

  /// Whether `lumen-app` should also flash the screen or camera flash.
  final bool useFlash;

  /// Severity used to prioritize this alert against others.
  final AlertSeverity severity;
}

/// Maps a [SoundAlertEvent.label] to how it should be presented.
///
/// `lumen-core` has no native sound classifier yet (see this package's
/// README), so nothing currently publishes real `SoundAlertEvent`s;
/// this mapping is ready for when it does.
class AlertPresentationMapper {
  static const _presentations = <String, AlertPresentation>{
    'doorbell': AlertPresentation(
      vibrationPatternMs: [200, 100, 200],
      useFlash: false,
      severity: AlertSeverity.info,
    ),
    'smoke_alarm': AlertPresentation(
      vibrationPatternMs: [500, 200, 500, 200, 500],
      useFlash: true,
      severity: AlertSeverity.critical,
    ),
    'siren': AlertPresentation(
      vibrationPatternMs: [500, 200, 500, 200, 500],
      useFlash: true,
      severity: AlertSeverity.critical,
    ),
    'baby_crying': AlertPresentation(
      vibrationPatternMs: [150, 150, 150],
      useFlash: false,
      severity: AlertSeverity.warning,
    ),
  };

  static const _fallback = AlertPresentation(
    vibrationPatternMs: [300],
    useFlash: false,
    severity: AlertSeverity.info,
  );

  /// Returns the presentation for [label], or a conservative fallback
  /// (a single short vibration, no flash, info severity) for an
  /// unrecognized label rather than silently dropping the alert.
  AlertPresentation presentationFor(String label) {
    return _presentations[label] ?? _fallback;
  }
}
