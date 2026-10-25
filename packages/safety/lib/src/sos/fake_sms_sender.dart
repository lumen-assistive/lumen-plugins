import 'sms_sender.dart';

/// Records SOS messages instead of sending them.
///
/// For tests only. There is no production [SmsSender] in this package;
/// see that interface's documentation for why.
class FakeSmsSender implements SmsSender {
  /// Every call made to [send], in order.
  final List<({String message, List<String> recipients})> sentMessages = [];

  @override
  Future<void> send({
    required String message,
    required List<String> recipients,
  }) async {
    sentMessages.add((message: message, recipients: recipients));
  }
}
