import 'package:flutter/material.dart';
import 'package:todo_list_school/logging/logging.dart';

import 'package:todo_list_school/ui/widgets/task_row/task_row_widget.dart';

final config = TaskWidgetConfiguration(
  index: 1,
  date: DateTime(1),
  isCompleted: false,
  relevance: Relevance.none,
  task:
      'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
);

class MainScreenModel extends ChangeNotifier {
  int _completedTasks = 0;
  bool _showCompleted = true;
  final List<TaskWidget> _tasks = [
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 0,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.low,
        task: 'Купить что-то, ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 1,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 2,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 3,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 4,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 5,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 6,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 7,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 8,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 9,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 10,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
    TaskWidget(
      configuration: TaskWidgetConfiguration(
        index: 11,
        date: DateTime(1),
        isCompleted: false,
        relevance: Relevance.none,
        task:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается… ',
      ),
    ),
  ];
  int get completedTasks => _completedTasks;
  bool get showCompleted => _showCompleted;

  void addTask({
    required TaskWidgetConfiguration configuration,
    required Type type,
  }) {
    _tasks.add(
      TaskWidget(
        configuration: TaskWidgetConfiguration(
          date: configuration.date,
          index: _tasks.length,
          isCompleted: configuration.isCompleted,
          relevance: configuration.relevance,
          task: configuration.task,
        ),
      ),
    );
    final log = logger(type);
    log.i('new task added');
    notifyListeners();
  }

  void changeTask({
    required TaskWidgetConfiguration configuration,
    required bool completed,
    required int index,
    required Type type,
  }) {
    _tasks[index] = TaskWidget(
      configuration: TaskWidgetConfiguration(
        date: configuration.date,
        index: index,
        isCompleted: completed,
        relevance: configuration.relevance,
        task: configuration.task,
      ),
    );
    final log = logger(type);
    log.i('task[$index] changed');
    notifyListeners();
  }

  void deleteTask(int index, Type type) {
    if (_tasks[index].configuration.isCompleted) {
      _completedTasks--;
    }
    _tasks.removeAt(index);
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].configuration.index = i;
    }
    final log = logger(type);
    log.i('task[$index] deleted');
    notifyListeners();
  }

  void finishTask(int index, Type type) {
    if (_tasks[index].configuration.isCompleted) {
      _completedTasks--;
    } else {
      _completedTasks++;
    }
    _tasks[index].configuration.isCompleted =
        !_tasks[index].configuration.isCompleted;
    final log = logger(type);
    log.i('task[$index] isCompleted changed');
    notifyListeners();
  }

  void recalculate(Type type) {
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].configuration.index = i;
    }
    final log = logger(type);
    log.i('index recaculation');
    notifyListeners();
  }

  List<Widget> getTasks() {
    if (_showCompleted) {
      return _tasks;
    } else {
      return _tasks
          .where((element) => element.configuration.isCompleted == false)
          .toList();
    }
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
