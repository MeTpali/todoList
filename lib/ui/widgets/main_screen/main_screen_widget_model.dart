import 'package:flutter/material.dart';
import 'package:todo_list_school/db/database_helper.dart';
import 'package:todo_list_school/domain/api_client/api_client.dart';
import 'package:todo_list_school/logging/logging.dart';
import 'package:todo_list_school/ui/widgets/task_row/task_row_widget.dart';

class MainScreenModel extends ChangeNotifier {
  final _client = ApiClient();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  int _completedTasks = 0;
  bool _showCompleted = false;
  List<TaskWidget> _taskList = [];
  int get completedTasks => _completedTasks;
  bool get showCompleted => _showCompleted;
  List<TaskWidget> get taskList => _showCompleted
      ? _taskList
      : _taskList
          .where((element) => element.configuration.isCompleted == false)
          .toList();

  Future<void> updateTaskList(Type type) async {
    final clientList = await _client.getTaskList();
    await _databaseHelper.initializeDatabase();
    final dbList = await _databaseHelper.getTaskList();
    if (clientList != dbList) {
      await _client.patchTaskList(dbList);
    }
    _taskList = dbList;
    _taskList.sort((a, b) => a.configuration.id.compareTo(b.configuration.id));
    _completedTasks = 0;
    for (var e in _taskList) {
      if (e.configuration.isCompleted) {
        _completedTasks++;
      }
    }
    final log = logger(type);
    log.i('task list updated');
    notifyListeners();
  }

  Future<void> deleteTask(int id, Type type) async {
    final log = logger(type);
    updateTaskList(type);
    await _client.deleteTask(id);
    int result = await _databaseHelper.deleteTask(id);
    if (result == 0) {
      log.e('error on task delete');
    } else {
      _taskList.removeWhere((element) {
        if (element.configuration.id == id) {
          if (element.configuration.isCompleted) {
            _completedTasks--;
          }
          return true;
        } else {
          return false;
        }
      });
      log.i('task deleted (id=$id)');
      updateTaskList(type);
    }
  }

  Future<void> changeTaskState(int id, Type type) async {
    final index =
        _taskList.indexWhere((element) => element.configuration.id == id);

    _taskList[index].configuration.isCompleted
        ? _completedTasks--
        : _completedTasks++;

    _taskList[index].configuration.isCompleted =
        !_taskList[index].configuration.isCompleted;

    await _databaseHelper.updateTask(_taskList[index].configuration);
    updateTaskList(type);

    final log = logger(type);
    log.i('task[$index] isCompleted changed');
  }

  void changeTaskList(Type type) {
    final log = logger(type);
    log.i('visibility button pressed');
    _showCompleted = !showCompleted;
    notifyListeners();
  }
}

class MainScreenModelProvider extends InheritedNotifier {
  final MainScreenModel model;
  const MainScreenModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );
  static MainScreenModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MainScreenModelProvider>();
  }

  static MainScreenModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MainScreenModelProvider>()
        ?.widget;
    return widget is MainScreenModelProvider ? widget : null;
  }
}
