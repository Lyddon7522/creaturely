import 'package:flutter/services.dart';

enum CloudRecoveryState {
  available,
  signedOut,
  offline,
  quotaExceeded,
  conflict,
  notConfigured,
  permissionDenied,
  unknownError,
}

class CloudSnapshotInfo {
  const CloudSnapshotInfo({required this.id, required this.createdAt, required this.byteLength});

  factory CloudSnapshotInfo.fromMap(Map<Object?, Object?> value) => CloudSnapshotInfo(
    id: value['id']! as String,
    createdAt: DateTime.parse(value['createdAt']! as String),
    byteLength: value['byteLength']! as int,
  );

  final String id;
  final DateTime createdAt;
  final int byteLength;
}

class CloudRecoveryException implements Exception {
  const CloudRecoveryException(this.state, this.message);

  final CloudRecoveryState state;
  final String message;

  @override
  String toString() => 'CloudRecoveryException(${state.name}): $message';
}

abstract interface class CloudRecoveryBridge {
  Future<CloudRecoveryState> status();
  Future<CloudRecoveryState> authorize();
  Future<void> upload(String id, Uint8List bytes, DateTime createdAt);
  Future<List<CloudSnapshotInfo>> list();
  Future<Uint8List> download(String id);
  Future<void> delete(String id);
}

class MethodChannelCloudRecoveryBridge implements CloudRecoveryBridge {
  const MethodChannelCloudRecoveryBridge({
    this.channel = const MethodChannel('com.vector42.creaturely/recovery'),
  });

  final MethodChannel channel;

  @override
  Future<CloudRecoveryState> authorize() async {
    try {
      final value = await channel.invokeMethod<String>('authorize');
      return _stateFrom(value);
    } on PlatformException catch (error) {
      _throwRecoveryError(error);
    }
  }

  @override
  Future<CloudRecoveryState> status() async {
    try {
      final value = await channel.invokeMethod<String>('status');
      return _stateFrom(value);
    } on PlatformException catch (error) {
      _throwRecoveryError(error);
    }
  }

  @override
  Future<void> upload(String id, Uint8List bytes, DateTime createdAt) async {
    try {
      await channel.invokeMethod<void>('upload', <String, Object?>{
        'id': id,
        'bytes': bytes,
        'createdAt': createdAt.toUtc().toIso8601String(),
      });
    } on PlatformException catch (error) {
      _throwRecoveryError(error);
    }
  }

  @override
  Future<List<CloudSnapshotInfo>> list() async {
    try {
      final values = await channel.invokeListMethod<Object?>('list') ?? const <Object?>[];
      return values
          .map((value) => CloudSnapshotInfo.fromMap(value! as Map<Object?, Object?>))
          .toList(growable: false);
    } on PlatformException catch (error) {
      _throwRecoveryError(error);
    }
  }

  @override
  Future<Uint8List> download(String id) async {
    try {
      final value = await channel.invokeMethod<Uint8List>('download', <String, Object?>{'id': id});
      if (value == null) {
        throw const CloudRecoveryException(
          CloudRecoveryState.unknownError,
          'Cloud provider returned no snapshot data.',
        );
      }
      return value;
    } on PlatformException catch (error) {
      _throwRecoveryError(error);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await channel.invokeMethod<void>('delete', <String, Object?>{'id': id});
    } on PlatformException catch (error) {
      _throwRecoveryError(error);
    }
  }

  CloudRecoveryState _stateFrom(String? value) {
    if (value == null) {
      return CloudRecoveryState.unknownError;
    }
    return CloudRecoveryState.values.where((state) => state.name == value).firstOrNull ??
        CloudRecoveryState.unknownError;
  }

  Never _throwRecoveryError(PlatformException error) {
    final state =
        CloudRecoveryState.values.where((value) => value.name == error.code).firstOrNull ??
        CloudRecoveryState.unknownError;
    throw CloudRecoveryException(state, error.message ?? _fallbackMessage(state));
  }

  String _fallbackMessage(CloudRecoveryState state) => switch (state) {
    CloudRecoveryState.signedOut => 'The platform cloud account is signed out.',
    CloudRecoveryState.offline => 'The cloud provider is offline.',
    CloudRecoveryState.quotaExceeded => 'Cloud storage is full.',
    CloudRecoveryState.conflict => 'The cloud provider reported a conflict.',
    CloudRecoveryState.notConfigured => 'Cloud recovery is not configured in this build.',
    CloudRecoveryState.permissionDenied => 'Cloud recovery permission was declined.',
    CloudRecoveryState.available => 'Cloud recovery is available.',
    CloudRecoveryState.unknownError => 'The cloud provider returned an unknown error.',
  };
}
