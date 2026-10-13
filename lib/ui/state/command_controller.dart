import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CommandController extends AsyncNotifier<void> {
  Future<void> _tail = Future.value();
  @override
  void build() {}

  Future<T> run<T>(Future<T> Function() action) {
    final operation = _tail.then((_) => _execute(action));
    _tail = operation.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return operation;
  }

  Future<T> _execute<T>(Future<T> Function() action) async {
    if (!ref.mounted) throw StateError('The operation was cancelled.');
    state = const AsyncLoading();
    try {
      final result = await action();
      if (ref.mounted) state = const AsyncData(null);
      return result;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      rethrow;
    }
  }
}
