import 'package:flutter/material.dart';

import 'package:todo_list_school/navigation/navigation.dart';
import 'package:todo_list_school/ui/theme/theme.dart';
import 'package:todo_list_school/ui/widgets/main_screen/main_screen_widget_model.dart';
import 'package:todo_list_school/ui/widgets/task_form/date.dart';

enum Relevance {
  none,
  high,
  low,
}

class TaskWidgetConfiguration {
  int index;
  final String task;
  final Relevance relevance;
  bool isCompleted;
  final DateTime? date;
  TaskWidgetConfiguration({
    required this.index,
    required this.isCompleted,
    required this.relevance,
    required this.task,
    required this.date,
  });
}

class TaskWidget extends StatelessWidget {
  final TaskWidgetConfiguration configuration;
  const TaskWidget({super.key, required this.configuration});
  @override
  Widget build(BuildContext context) {
    return TaskRowWidget(configuration: configuration);
  }
}

class TaskRowWidget extends StatelessWidget {
  const TaskRowWidget({super.key, required this.configuration});

  final TaskWidgetConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    final model = MainScreenModelProvider.watch(context)?.model;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft:
            configuration.index == 0 ? const Radius.circular(10) : Radius.zero,
        topRight:
            configuration.index == 0 ? const Radius.circular(10) : Radius.zero,
      ),
      child: Dismissible(
        background: Container(
          color: Colors.greenAccent,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 27),
              Icon(
                Icons.check,
                color: Colors.white,
              )
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.redAccent,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              SizedBox(width: 27),
            ],
          ),
        ),
        key: ValueKey(configuration.index),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            model!.finishTask(configuration.index, TaskRowWidget);
            return false;
          } else {
            model!.deleteTask(configuration.index, TaskRowWidget);
            return false;
          }
        },
        movementDuration: Duration.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(19, 15, 0, 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                configuration.isCompleted
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: configuration.isCompleted
                    ? ToDoListTheme.taskRowCheckBoxCompletedColor
                    : configuration.relevance == Relevance.high
                        ? ToDoListTheme.taskRowCheckBoxHighRelevanceColor
                        : ToDoListTheme.taskRowCheckBoxSimpleColor,
              ),
              SizedBox(
                width: configuration.relevance == Relevance.high ? 10 : 15,
              ),
              if (configuration.relevance == Relevance.high)
                const SizedBox(
                  width: 10,
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: Colors.red,
                  ),
                ),
              if (configuration.relevance == Relevance.high)
                const Icon(
                  Icons.priority_high_rounded,
                  color: Colors.red,
                ),
              if (configuration.relevance == Relevance.low)
                Icon(
                  Icons.arrow_downward_rounded,
                  color: ToDoListTheme.taskRowLowRelevanceColor,
                  size: 20,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        configuration.task,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: configuration.isCompleted
                              ? ToDoListTheme.completedTextColor
                              : ToDoListTheme.textColor,
                          decoration: configuration.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (configuration.date != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${configuration.date!.day} ${Date.getMonth(configuration.date!.month)} ${configuration.date!.year}',
                          style:
                              TextStyle(color: ToDoListTheme.taskRowDateColor),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              IconButton(
                padding: const EdgeInsets.only(right: 18),
                constraints: const BoxConstraints(),
                onPressed: () async {
                  final result =
                      await NavigationManager.instance.openInfo(configuration);
                  if (result != null) {
                    if (result[1] == true) {
                      model!.deleteTask(configuration.index, TaskRowWidget);
                    } else {
                      model!.changeTask(
                        configuration: result[0] as TaskWidgetConfiguration,
                        completed: configuration.isCompleted,
                        index: configuration.index,
                        type: TaskRowWidget,
                      );
                    }
                  }
                },
                icon: Icon(
                  Icons.info_outline,
                  color: ToDoListTheme.taskRowCheckBoxInfoButtonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
