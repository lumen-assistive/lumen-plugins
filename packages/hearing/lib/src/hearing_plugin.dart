import 'dart:async';

import 'package:lumen_sdk/lumen_sdk.dart';

import 'alert_presentation.dart';
import 'transcript_session.dart';

/// The Hearing module (Italian: Sentire).
///
/// Aggregates live transcript segments into sessions and turns
/// recognized non-speech sounds into a presentation `lumen-app` can
/// act on. See the package README for what is and is not implemented
/// yet.
class HearingPlugin implements LumenPlugin {
  final AlertPresentationMapper _presentationMapper = AlertPresentationMapper();

  StreamSubscription<TranscriptEvent>? _transcriptSubscription;
  StreamSubscription<SoundAlertEvent>? _soundSubscription;
  TranscriptSession? _currentSession;
  late PluginContext _context;

  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'hearing',
    nameIt: 'Sentire',
    nameEn: 'Hearing',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [PluginCapability.microphone],
  );

  /// The open transcript session, if captioning is currently active.
  TranscriptSession? get currentSession => _currentSession;

  @override
  Future<void> initialize(PluginContext context) async {
    _context = context;
  }

  @override
  Future<void> start() async {
    _currentSession = TranscriptSession();

    _transcriptSubscription = _context.eventBus.on<TranscriptEvent>().listen((
      event,
    ) {
      if (event.isFinal) {
        _currentSession?.addSegment(event);
      }
    });

    _soundSubscription = _context.eventBus.on<SoundAlertEvent>().listen((
      event,
    ) {
      final presentation = _presentationMapper.presentationFor(event.label);
      _context.eventBus.publish(
        AlertEvent(
          timestamp: event.timestamp,
          pluginId: manifest.id,
          severity: presentation.severity,
          messageIt: _italianMessageFor(event.label),
          messageEn: _englishMessageFor(event.label),
        ),
      );
    });
  }

  @override
  Future<void> stop() async {
    await _transcriptSubscription?.cancel();
    _transcriptSubscription = null;
    await _soundSubscription?.cancel();
    _soundSubscription = null;
    _currentSession = null;
  }

  @override
  Future<void> dispose() async {
    await stop();
  }

  String _italianMessageFor(String label) {
    switch (label) {
      case 'doorbell':
        return 'È suonato il campanello.';
      case 'smoke_alarm':
        return 'Rilevato un allarme antincendio.';
      case 'siren':
        return 'Rilevata una sirena.';
      case 'baby_crying':
        return 'Il bambino sta piangendo.';
      default:
        return 'Rilevato un suono: $label.';
    }
  }

  String _englishMessageFor(String label) {
    switch (label) {
      case 'doorbell':
        return 'The doorbell rang.';
      case 'smoke_alarm':
        return 'A smoke alarm was detected.';
      case 'siren':
        return 'A siren was detected.';
      case 'baby_crying':
        return 'A baby is crying.';
      default:
        return 'Detected sound: $label.';
    }
  }
}
