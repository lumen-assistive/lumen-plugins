/// Sends an SOS message to a list of recipients.
///
/// `lumen_plugin_protezione` deliberately ships no implementation of
/// this interface: the actual platform SMS channel is native code that
/// belongs to `lumen-app`. Without a concrete [SmsSender] injected by
/// the host app, [SosController] can run a full countdown and reach the
/// "ready to send" point but can never actually send a message. This is
/// true by construction, not by convention, so a test run can never
/// trigger a real SMS.
abstract class SmsSender {
  /// Sends [message] to every number in [recipients].
  Future<void> send({
    required String message,
    required List<String> recipients,
  });
}
