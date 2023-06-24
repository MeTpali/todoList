import 'package:flutter/material.dart';
import 'package:todo_list_school/db/database_helper.dart';
import 'package:todo_list_school/domain/api_client.dart';
import 'package:todo_list_school/logging/logging.dart';
import 'package:todo_list_school/navigation/navigation.dart';
import '../../theme/theme.dart';
import '../task_row/task_row_widget.dart';
import 'date.dart';

class TaskFormModel extends ChangeNotifier {
  final _client = ApiClient();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  int? id;
  bool? isCompleted;
  String _taskText = '';
  Relevance _relevance = Relevance.none;
  bool _isDated = false;
  String? _date;
  bool isChanging = false;
  var controller = TextEditingController();

  Relevance get relevance => _relevance;
  bool get isDated => _isDated;
  String? get date => _date;
  String get taskText => _taskText;

  set relevance(Relevance value) {
    _relevance = value;
    notifyListeners();
  }

  set taskText(String value) {
    final isTaskTextEmpty = _taskText.trim().isEmpty;
    _taskText = value;
    if (value.trim().isEmpty != isTaskTextEmpty) {
      notifyListeners();
    }
  }

  void inChange() {
    isChanging = true;
    notifyListeners();
  }

  void setDateValue(String date) {
    _date = date;
    notifyListeners();
  }

  void changeDateValue(DateTime date, Type type) {
    final log = logger(type);
    log.i('task date changed');
    _date = '${date.day} ${Date.getMonth(date.month)} ${date.year}';
    notifyListeners();
  }

  void setDate() {
    if (!_isDated) {
      _isDated = true;
    } else {
      _isDated = false;
      _date = null;
    }
    notifyListeners();
  }

  Widget? getDate(Type type) {
    final log = logger(type);
    log.i('date condition changed');
    if (_isDated) {
      return Text(
        _date!,
        style: TextStyle(color: ToDoListTheme.taskFormDateColor),
      );
    } else {
      return null;
    }
  }

  void pickRelevance(Relevance relevance, Type type) {
    final log = logger(type);
    log.i('task relevance picked');
    _relevance = relevance;
    notifyListeners();
  }

  void saveTask(Type type) async {
    final log = logger(type);
    log.i('task saved');
    await _databaseHelper.insertTask(
      TaskWidgetConfiguration(
        id: 0,
        isCompleted: false,
        relevance: _relevance,
        description: _taskText,
        date: _date,
      ),
    );
    final taskList = await _databaseHelper.getTaskList();
    int minId = 0;
    for (int i = 0; i < taskList.length; i++) {
      minId < taskList[i].configuration.id
          ? minId = taskList[i].configuration.id
          : minId;
    }
    await _client.postTask(
      TaskWidgetConfiguration(
        id: minId,
        isCompleted: false,
        relevance: _relevance,
        description: _taskText,
        date: _date,
      ),
    );
    NavigationManager.instance.saveTask(true);
  }

  void updateTask(Type type) async {
    final log = logger(type);
    log.i('task updated');
    await _databaseHelper.updateTask(
      TaskWidgetConfiguration(
        id: id!,
        isCompleted: isCompleted!,
        relevance: _relevance,
        description: _taskText,
        date: _date,
      ),
    );
    final list = await _client.getTaskList();
    bool flag = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i].configuration.id == id) {
        flag = true;
      }
    }
    flag
        ? await _client.updateTask(
            TaskWidgetConfiguration(
              id: id!,
              isCompleted: isCompleted!,
              relevance: _relevance,
              description: _taskText,
              date: _date,
            ),
          )
        : await _client.postTask(
            TaskWidgetConfiguration(
              id: id!,
              isCompleted: isCompleted!,
              relevance: _relevance,
              description: _taskText,
              date: _date,
            ),
          );
    NavigationManager.instance.saveTask(false);
  }

  void deleteTask(Type type) {
    NavigationManager.instance.saveTask(true);
  }

  TextEditingController getController() {
    controller.text = _taskText;
    controller.addListener(() => _taskText = controller.text);
    return controller;
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    controller.dispose();
    super.dispose();
  }
}

class TaskFormWidgetProvider extends InheritedNotifier {
  final TaskFormModel model;
  const TaskFormWidgetProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );
  static TaskFormWidgetProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskFormWidgetProvider>();
  }

  static TaskFormWidgetProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetProvider>()
        ?.widget;
    return widget is TaskFormWidgetProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<Listenable> oldWidget) {
    return true;
  }
}
