import 'package:flutter/widgets.dart';
import 'package:todo_list_school/logging/logging.dart';

class NavigationLogger extends NavigatorObserver {
  final log = logger(NavigationLogger);
  @override
  void didPush(Route route, Route? previousRoute) {
    log.i('didPush: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    log.i('didPop: ${route.settings.name}');
  }

  @override
  void didStopUserGesture() {}

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {}

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {}

  @override
  void didRemove(Route route, Route? previousRoute) {}
}
