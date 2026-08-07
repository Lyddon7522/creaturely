import 'package:creaturely/platform/cloud_recovery_bridge.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.vector42.creaturely/test-recovery');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('unknown native recovery states degrade safely', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async => 'futureProviderState',
    );
    const bridge = MethodChannelCloudRecoveryBridge(channel: channel);

    expect(await bridge.status(), CloudRecoveryState.unknownError);
  });

  test('native provider errors retain their typed recovery state', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async =>
          throw PlatformException(code: 'quotaExceeded', message: 'Provider storage is full.'),
    );
    const bridge = MethodChannelCloudRecoveryBridge(channel: channel);

    await expectLater(
      bridge.upload('snapshot-1', Uint8List.fromList(<int>[1, 2, 3]), DateTime.utc(2026, 7, 28)),
      throwsA(
        isA<CloudRecoveryException>()
            .having((error) => error.state, 'state', CloudRecoveryState.quotaExceeded)
            .having((error) => error.message, 'message', 'Provider storage is full.'),
      ),
    );
  });
}
