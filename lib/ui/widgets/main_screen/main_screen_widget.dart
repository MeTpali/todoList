import 'package:flutter/material.dart';
import 'package:todo_list_school/navigation/navigation.dart';
import 'package:todo_list_school/ui/theme/theme.dart';
import 'package:todo_list_school/ui/widgets/main_screen/main_screen_widget_model.dart';
import 'package:todo_list_school/ui/widgets/task_row/task_row_widget.dart';

import '../../localization/s.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  late final MainScreenModel _model;

  @override
  void initState() {
    super.initState();
    _model = MainScreenModel();
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    return Scaffold(
      backgroundColor: ToDoListTheme.mainScreenScaffoldColor,
      body: MainScreenModelProvider(
        model: model,
        child: const CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(expandedHeight: 120),
              pinned: true,
            ),
            CompletedWidget(),
            TasksWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTaskForm,
        backgroundColor: ToDoListTheme.floatingActionButtonBackgroundColor,
        child: Icon(
          Icons.add,
          color: ToDoListTheme.floatingActionButtonIconColor,
        ),
      ),
    );
  }

  Future<void> _openTaskForm() async {
    final result = await NavigationManager.instance.openTaskForm();
    if (result != null) {
      _model.addTask(
          configuration: result[0] as TaskWidgetConfiguration,
          type: MainScreenWidget);
    }
  }
}

class CompletedWidget extends StatelessWidget {
  const CompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = MainScreenModelProvider.watch(context)?.model;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: 38,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 6, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${S.of(context).get("done")} — ${model!.completedTasks}",
                        style: TextStyle(
                          color: ToDoListTheme.mainScreenCompletedColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(right: 25),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    model.showCompleted
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  color: ToDoListTheme.mainScreenEyeColor,
                  splashColor: Colors.transparent,
                  onPressed: () => model.changeTaskList(CompletedWidget),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TasksWidget extends StatelessWidget {
  const TasksWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = MainScreenModelProvider.watch(context)?.model;
    final tasks = model!.getTasks();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
        child: Material(
          color: ToDoListTheme.mainScreenTaskListColor,
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: tasks,
              ),
              TextButton(
                onPressed: () async {
                  final result =
                      await NavigationManager.instance.openTaskForm();
                  if (result != null) {
                    model.addTask(
                      configuration: result[0] as TaskWidgetConfiguration,
                      type: TasksWidget,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).get("new"),
                        style: TextStyle(
                          color: ToDoListTheme.mainScreenNewColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  const CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        BuildAppBar(shrinkOffset: shrinkOffset, expandedHeight: expandedHeight)
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class BuildAppBar extends StatelessWidget {
  const BuildAppBar(
      {super.key, required this.shrinkOffset, required this.expandedHeight});
  final double shrinkOffset;
  final double expandedHeight;

  double appear(double shrinkOffset) => shrinkOffset < 55 ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    final model = MainScreenModelProvider.watch(context)?.model;
    return Material(
      color: ToDoListTheme.mainScreenAppBarColor,
      elevation: 4 * shrinkOffset / expandedHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              60 - 44 * shrinkOffset / expandedHeight,
              0,
              0,
              16 * shrinkOffset / expandedHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  S.of(context).get("myBusiness"),
                  style: TextStyle(
                    fontSize: 32 - 12 * shrinkOffset / expandedHeight,
                    fontWeight: FontWeight.bold,
                    color: ToDoListTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: appear(shrinkOffset),
            child: IconButton(
              padding: const EdgeInsets.fromLTRB(0, 0, 19, 14),
              constraints: const BoxConstraints(),
              icon: Icon(
                model!.showCompleted ? Icons.visibility : Icons.visibility_off,
              ),
              color: ToDoListTheme.mainScreenEyeColor,
              splashColor: Colors.transparent,
              onPressed: appear(shrinkOffset) == 1
                  ? () => model.changeTaskList(BuildAppBar)
                  : () {},
            ),
          ),
        ],
      ),
    );
  }
}
