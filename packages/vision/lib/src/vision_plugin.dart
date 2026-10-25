import 'dart:async';

import 'package:lumen_sdk/lumen_sdk.dart';

import 'expiry_date_parser.dart';

/// Lumen's Vision module (Italian: Vedere).
///
/// Subscribes to [OcrResultEvent] and publishes an [AlertEvent] when an
/// expiry date is found in the recognized text. See the package
/// README for which original Vision features are not implemented yet.
class VisionPlugin implements LumenPlugin {
  /// Creates the plugin, optionally with a custom [ExpiryDateParser]
  /// for testing.
  VisionPlugin({ExpiryDateParser? expiryDateParser})
      : _expiryDateParser = expiryDateParser ?? ExpiryDateParser();

  final ExpiryDateParser _expiryDateParser;

  StreamSubscription<OcrResultEvent>? _subscription;
  late PluginContext _context;

  @override
  final PluginManifest manifest = const PluginManifest(
    id: 'vision',
    nameIt: 'Vedere',
    nameEn: 'Vision',
    version: '0.1.0',
    sdkConstraint: '^0.1.0',
    capabilities: [PluginCapability.camera],
  );

  @override
  Future<void> initialize(PluginContext context) async {
    _context = context;
  }

  @override
  Future<void> start() async {
    _subscription = _context.eventBus.on<OcrResultEvent>().listen(_onOcrResult);
  }

  void _onOcrResult(OcrResultEvent event) {
    final result = _expiryDateParser.parse(event.text);
    final date = result.date;
    if (date == null) return;

    _context.eventBus.publish(
      AlertEvent(
        timestamp: DateTime.now(),
        pluginId: manifest.id,
        severity: AlertSeverity.info,
        messageIt: 'Data di scadenza rilevata: ${_formatItalian(date)}.',
        messageEn: 'Expiry date detected: ${_formatEnglish(date)}.',
      ),
    );
  }

  String _formatItalian(DateTime date) =>
      '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';

  String _formatEnglish(DateTime date) =>
      '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  Future<void> dispose() async {
    await stop();
  }
}
