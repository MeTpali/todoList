import 'package:flutter/material.dart';
import 'package:todo_list_school/navigation/navigation.dart';
import 'package:todo_list_school/ui/theme/theme.dart';

import '../../localization/s.dart';
import '../task_row/task_row_widget.dart';
import 'task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({super.key, required this.config});
  final TaskWidgetConfiguration? config;

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormModel _model;
  @override
  void initState() {
    super.initState();
    _model = TaskFormModel();
    if (widget.config != null) {
      _model.taskText = widget.config!.task;
      _model.relevance = widget.config!.relevance;
      _model.isChanging = true;
      if (widget.config!.date != null) {
        _model.changeDateValue(widget.config!.date!, TaskFormWidget);
        _model.setDate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetProvider(
      model: _model,
      child: TaskFormBody(
        text: widget.config == null ? '' : widget.config!.task,
      ),
    );
  }
}

class TaskFormBody extends StatefulWidget {
  const TaskFormBody({super.key, required this.text});
  final String text;

  @override
  State<TaskFormBody> createState() => _TaskFormBodyState();
}

class _TaskFormBodyState extends State<TaskFormBody> {
  double offset = 0;
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        offset = _controller.positions.isEmpty ? 0 : _controller.offset;
      });
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetProvider.watch(context)?.model;
    return Scaffold(
      backgroundColor: ToDoListTheme.taskFormScaffoldColor,
      appBar: AppBar(
        backgroundColor: ToDoListTheme.taskFormAppBarColor,
        elevation: offset < 100 ? 4 * offset / 100 : 4,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: ToDoListTheme.taskFormAppBarIconColor,
          ),
          onPressed: _pop,
        ),
        actions: [
          TextButton(
            onPressed:
                model!.taskText.isNotEmpty ? () => _saveTask(model) : null,
            child: Text(
              S.of(context).get("save").toUpperCase(),
              style: TextStyle(
                color: ToDoListTheme.taskFormAppBarSaveColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskFieldWidget(text: widget.text),
                  const SizedBox(height: 28),
                  Text(
                    S.of(context).get("relevance"),
                    style: TextStyle(
                      color: ToDoListTheme.textColor,
                    ),
                  ),
                  const RelevancePoPup(),
                  const Divider(height: 32),
                  const DatePicker(),
                ],
              ),
            ),
            const Divider(height: 26),
            const DeleteWidget(),
            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }

  void _pop() {
    NavigationManager.instance.pop();
  }

  void _saveTask(
    TaskFormModel model,
  ) {
    model.saveTask(TaskFormBody);
  }
}

class TaskFieldWidget extends StatefulWidget {
  const TaskFieldWidget({super.key, required this.text});
  final String text;

  @override
  State<TaskFieldWidget> createState() => _TaskFieldWidgetState();
}

class _TaskFieldWidgetState extends State<TaskFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetProvider.watch(context)!.model;
    return Material(
      color: ToDoListTheme.taskFormTextFieldColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: TextField(
          controller: model.isChanging ? model.getController() : null,
          minLines: 4,
          maxLines: 30,
          style: TextStyle(
            color: ToDoListTheme.taskFormTextColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).get("smthShouldBeDone"),
            hintStyle: TextStyle(color: ToDoListTheme.taskFormHintTextColor),
          ),
          onChanged: (value) => model.taskText = value,
        ),
      ),
    );
  }
}

class RelevancePoPup extends StatelessWidget {
  const RelevancePoPup({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetProvider.watch(context)?.model;
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton(
        elevation: 3,
        color: ToDoListTheme.taskFormPopupMenuColor,
        surfaceTintColor: Colors.transparent,
        initialValue: model!.relevance,
        onSelected: (Relevance item) =>
            model.pickRelevance(item, RelevancePoPup),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Relevance>>[
          PopupMenuItem<Relevance>(
            value: Relevance.none,
            child: Text(
              S.of(context).get("none"),
              style: TextStyle(color: ToDoListTheme.textColor),
            ),
          ),
          PopupMenuItem<Relevance>(
            value: Relevance.low,
            child: Text(
              S.of(context).get("low"),
              style: TextStyle(color: ToDoListTheme.textColor),
            ),
          ),
          PopupMenuItem<Relevance>(
            value: Relevance.high,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 10,
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
                const Icon(
                  Icons.priority_high_rounded,
                  color: Colors.red,
                  size: 16,
                ),
                Text(
                  S.of(context).get("high"),
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: model.relevance == Relevance.none
              ? Text(
                  S.of(context).get('none'),
                  style: TextStyle(
                    color: ToDoListTheme.taskFormNoneRelevanceColor,
                  ),
                )
              : model.relevance == Relevance.low
                  ? Text(
                      S.of(context).get("low"),
                      style: TextStyle(
                        color: ToDoListTheme.taskFormLowRelevanceColor,
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 10,
                          child: Icon(
                            Icons.priority_high_rounded,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          child: Icon(
                            Icons.priority_high_rounded,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                        Text(
                          S.of(context).get('high'),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2023, 6, 12));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor:
                ToDoListTheme.taskFormDatePickerDialogBackgroundColor,
            colorScheme: ColorScheme.light(
              primary: ToDoListTheme.taskFormDatePickerPrimaryColor,
              onSurface: ToDoListTheme.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  ToDoListTheme.taskFormDatePickerButtonsColor,
                ),
              ),
            ),
          ),
          child: DatePickerDialog(
            cancelText: S.of(context).get("cancel").toUpperCase(),
            confirmText: S.of(context).get("ok").toUpperCase(),
            restorationId: 'date_picker_dialog',
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
            firstDate: DateTime(2023),
            lastDate: DateTime(2031),
          ),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    final model = TaskFormWidgetProvider.watch(context)?.model;
    if (newSelectedDate != null) {
      setState(() {
        model!.changeDateValue(newSelectedDate, DatePicker);
        model.setDate();
        _selectedDate.value = newSelectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetProvider.watch(context)?.model;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                S.of(context).get('makeTo'),
                style: TextStyle(
                  color: ToDoListTheme.textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: FittedBox(
                child: model!.getDate(DatePicker),
              ),
            ),
          ],
        ),
        Switch(
          value: model.isDated,
          trackColor: model.isDated
              ? MaterialStateProperty.all(
                  ToDoListTheme.taskFormTrackActiveSwitchColor)
              : MaterialStateProperty.all(
                  ToDoListTheme.taskFormTrackSwitchColor),
          inactiveThumbColor: ToDoListTheme.taskFormInactiveThumbSwitchColor,
          activeColor: ToDoListTheme.taskFormActiveSwitchColor,
          onChanged: (bool value) {
            if (value) {
              _restorableDatePickerRouteFuture.present();
            } else {
              model.setDate();
            }
          },
        ),
      ],
    );
  }
}

class DeleteWidget extends StatelessWidget {
  const DeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetProvider.read(context)?.model;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextButton(
        onPressed:
            model!.isChanging ? () => model.deleteTask(DeleteWidget) : null,
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: model.isChanging
                  ? ToDoListTheme.taskFormDeleteColor
                  : ToDoListTheme.taskFormDisableDeleteColor,
            ),
            const SizedBox(width: 10),
            Text(
              S.of(context).get('delete'),
              style: TextStyle(
                color: model.isChanging
                    ? ToDoListTheme.taskFormDeleteColor
                    : ToDoListTheme.taskFormDisableDeleteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
