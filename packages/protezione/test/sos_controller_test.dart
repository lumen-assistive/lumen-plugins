import 'package:lumen_plugin_protezione/lumen_plugin_protezione.dart';
import 'package:lumen_plugin_protezione/lumen_plugin_protezione_testing.dart';
import 'package:test/test.dart';

void main() {
  group('SosController', () {
    test('sends through the configured SmsSender once the window elapses',
        () async {
      final sender = FakeSmsSender();
      final controller = SosController(
        smsSender: sender,
        cancelWindow: const Duration(milliseconds: 20),
      );

      await controller.trigger(
        message: 'Aiuto, ho bisogno di assistenza.',
        recipients: ['+390000000000'],
      );

      expect(controller.state, SosState.sent);
      expect(sender.sentMessages, hasLength(1));
      expect(sender.sentMessages.single.recipients, ['+390000000000']);
    });

    test('cancels without sending when cancelled in time', () async {
      final sender = FakeSmsSender();
      final controller = SosController(
        smsSender: sender,
        cancelWindow: const Duration(milliseconds: 100),
      );

      final future = controller.trigger(
        message: 'Aiuto',
        recipients: ['+390000000000'],
      );
      expect(controller.state, SosState.countdown);

      controller.cancel();
      await future;

      expect(controller.state, SosState.cancelled);
      expect(sender.sentMessages, isEmpty);
    });

    test('cancel is a no-op when not counting down', () {
      final controller = SosController(smsSender: FakeSmsSender());

      expect(() => controller.cancel(), returnsNormally);
      expect(controller.state, SosState.idle);
    });

    test('rejects a second trigger while counting down', () async {
      final controller = SosController(
        smsSender: FakeSmsSender(),
        cancelWindow: const Duration(milliseconds: 50),
      );

      final first = controller.trigger(message: 'Aiuto', recipients: []);

      expect(
        () => controller.trigger(message: 'Aiuto', recipients: []),
        throwsStateError,
      );

      await first;
    });

    test('reset allows triggering again after completion', () async {
      final sender = FakeSmsSender();
      final controller = SosController(
        smsSender: sender,
        cancelWindow: const Duration(milliseconds: 10),
      );

      await controller.trigger(message: 'Aiuto', recipients: []);
      expect(controller.state, SosState.sent);

      controller.reset();
      expect(controller.state, SosState.idle);

      await controller.trigger(message: 'Aiuto di nuovo', recipients: []);
      expect(sender.sentMessages, hasLength(2));
    });

    test('reset throws while a countdown is in progress', () async {
      final controller = SosController(
        smsSender: FakeSmsSender(),
        cancelWindow: const Duration(milliseconds: 50),
      );

      final future = controller.trigger(message: 'Aiuto', recipients: []);

      expect(() => controller.reset(), throwsStateError);

      controller.cancel();
      await future;
    });
  });
}
