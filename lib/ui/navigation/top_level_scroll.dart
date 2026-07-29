import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TopLevelDestination { animals, trends, timeline, schedule }

typedef ScrollToTopCallback = void Function();

final topLevelScrollCoordinatorProvider = Provider<TopLevelScrollCoordinator>(
  (ref) => TopLevelScrollCoordinator(),
);

class TopLevelScrollCoordinator {
  final Map<TopLevelDestination, ScrollToTopCallback> _callbacks =
      <TopLevelDestination, ScrollToTopCallback>{};

  void register(TopLevelDestination destination, ScrollToTopCallback callback) {
    _callbacks[destination] = callback;
  }

  void unregister(TopLevelDestination destination, ScrollToTopCallback callback) {
    if (identical(_callbacks[destination], callback)) {
      _callbacks.remove(destination);
    }
  }

  void scrollToTop(TopLevelDestination destination) {
    _callbacks[destination]?.call();
  }
}

void animateTopLevelScrollToStart(BuildContext context, ScrollController controller) {
  if (!controller.hasClients) {
    return;
  }
  if (MediaQuery.disableAnimationsOf(context)) {
    controller.jumpTo(controller.position.minScrollExtent);
    return;
  }
  controller.animateTo(
    controller.position.minScrollExtent,
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
  );
}
