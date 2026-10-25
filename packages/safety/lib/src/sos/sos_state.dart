/// Lifecycle of an SOS request driven by [SosController].
enum SosState {
  /// No SOS in progress.
  idle,

  /// Counting down; the user can still call `cancel`.
  countdown,

  /// The countdown elapsed and the message was handed to the
  /// configured `SmsSender`.
  sent,

  /// The user cancelled during the countdown.
  cancelled,
}
