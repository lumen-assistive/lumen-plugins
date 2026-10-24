import 'dart:async';

import 'sms_sender.dart';
import 'sos_state.dart';

/// Drives the offline SOS flow: a countdown the user can cancel, after
/// which a message is sent through the injected [SmsSender].
///
/// The cancel window exists so a false trigger (for example from
/// [FallDetector]) never sends a message without the user having a
/// real chance to stop it first.
class SosController {
  /// Creates a controller. [cancelWindow] is how long the user has to
  /// call [cancel] after [trigger] before the message is sent.
  SosController({
    required SmsSender smsSender,
    this.cancelWindow = const Duration(seconds: 10),
  }) : _smsSender = smsSender;

  final SmsSender _smsSender;

  /// How long the user has to cancel after [trigger] before the
  /// message is sent.
  final Duration cancelWindow;

  SosState _state = SosState.idle;
  Completer<void>? _cancelCompleter;

  /// Current lifecycle state.
  SosState get state => _state;

  /// Starts the countdown and, unless [cancel] is called first, sends
  /// [message] to [recipients] through the configured [SmsSender] once
  /// [cancelWindow] elapses.
  ///
  /// Throws a [StateError] if a countdown is already in progress.
  /// Completes once the message has been sent or the countdown was
  /// cancelled; check [state] afterwards to tell which.
  Future<void> trigger({
    required String message,
    required List<String> recipients,
  }) async {
    if (_state == SosState.countdown) {
      throw StateError('An SOS countdown is already in progress.');
    }

    _state = SosState.countdown;
    _cancelCompleter = Completer<void>();

    final cancelled = await _waitForCancelOrTimeout();
    if (cancelled) {
      _state = SosState.cancelled;
      return;
    }

    await _smsSender.send(message: message, recipients: recipients);
    _state = SosState.sent;
  }

  /// Cancels an in-progress countdown. Does nothing if not counting
  /// down.
  void cancel() {
    if (_state != SosState.countdown) return;
    _cancelCompleter?.complete();
  }

  /// Resets a completed or cancelled controller back to
  /// [SosState.idle] so [trigger] can be called again.
  ///
  /// Throws a [StateError] if a countdown is currently in progress.
  void reset() {
    if (_state == SosState.countdown) {
      throw StateError('Cannot reset while a countdown is in progress.');
    }
    _state = SosState.idle;
    _cancelCompleter = null;
  }

  Future<bool> _waitForCancelOrTimeout() async {
    final completer = _cancelCompleter!;
    final timeout = Future<void>.delayed(cancelWindow);
    return Future.any<bool>([
      completer.future.then((_) => true),
      timeout.then((_) => false),
    ]);
  }
}
