import 'package:flutter/material.dart';
import 'package:todo_list_school/logging/logging.dart';
// import 'package:todo_list_school/logging/logging.dart';
import 'package:todo_list_school/navigation/navigation.dart';
// import 'package:todo_list_school/ui/widgets/task_form/task_form_widget.dart';
import '../../theme/theme.dart';
import '../task_row/task_row_widget.dart';
import 'date.dart';

class TaskFormModel extends ChangeNotifier {
  String _taskText = '';
  Relevance _relevance = Relevance.none;
  bool _isDated = false;
  DateTime? _date;
  bool isChanging = false;
  var controller = TextEditingController();

  Relevance get relevance => _relevance;
  bool get isDated => _isDated;
  DateTime? get date => _date;
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

  void changeDateValue(DateTime date, Type type) {
    final log = logger(type);
    log.i('task date changed');
    _date = date;
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
        '${_date!.day} ${Date.getMonth(_date!.month)} ${_date!.year}',
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

  void saveTask(Type type) {
    final log = logger(type);
    log.i('task saved');
    NavigationManager.instance.saveTask(
      [
        TaskWidgetConfiguration(
          index: 0,
          isCompleted: false,
          relevance: _relevance,
          task: _taskText,
          date: _date,
        ),
        false,
      ],
    );
  }

  void deleteTask(Type type) {
    final log = logger(type);
    log.i('task deleted');
    NavigationManager.instance.saveTask(
      [
        TaskWidgetConfiguration(
          index: 0,
          isCompleted: false,
          relevance: _relevance,
          task: _taskText,
          date: _date,
        ),
        true,
      ],
    );
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
