import 'package:flutter/material.dart';

import '../ui/widgets/task_row/task_row_widget.dart';
import 'observer.dart';
import 'routes.dart';

class NavigationManager {
  NavigationManager._();

  static final instance = NavigationManager._();

  final key = GlobalKey<NavigatorState>();

  final observers = <NavigatorObserver>[
    NavigationLogger(),
  ];

  NavigatorState get _navigator => key.currentState!;

  // void openTaskForm() {
  //   _navigator.pushNamed(RouteNames.taskForm);
  // }

  Future<List<dynamic>?> openInfo(TaskWidgetConfiguration? configuration) {
    return _navigator.pushNamed<List<dynamic>?>(
      RouteNames.taskForm,
      arguments: configuration,
    );
  }

  Future<List<dynamic>?> openTaskForm() {
    return _navigator.pushNamed<List<dynamic>?>(
      RouteNames.taskForm,
    );
  }

  void maybePop<T extends Object>([T? result]) {
    _navigator.maybePop(result);
  }

  void pop<T extends Object>() {
    _navigator.pop();
  }

  void saveTask<T extends Object>([T? result]) {
    _navigator.pop(result);
  }

  void popToHome() {
    _navigator.popUntil(ModalRoute.withName(RouteNames.home));
  }
}
