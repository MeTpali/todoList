import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_school/navigation/navigation.dart';
import 'package:todo_list_school/ui/theme/theme.dart';
import 'package:todo_list_school/ui/widgets/main_screen/main_screen_bloc.dart';
import 'package:todo_list_school/ui/localization/s.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final model = _model;
    return BlocProvider(
      create: (context) => MainScreenBloc(const MainScreenState.inital()),
      child: Scaffold(
        backgroundColor: ToDoListTheme.mainScreenScaffoldColor,
        body: const CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(expandedHeight: 120),
              pinned: true,
            ),
            CompletedWidget(),
            TasksWidget(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final bloc = context.read<MainScreenBloc>();
            bool? update = await NavigationManager.instance.openTaskForm();
            if (update != null && update) {
              bloc.add(MainScreenTaskListUpdate());
            }
          },
          backgroundColor: ToDoListTheme.floatingActionButtonBackgroundColor,
          child: Icon(
            Icons.add,
            color: ToDoListTheme.floatingActionButtonIconColor,
          ),
        ),
      ),
    );
  }
}

class CompletedWidget extends StatelessWidget {
  const CompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MainScreenBloc>();
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
                        "${S.of(context).get("done")} — ${bloc.state.taskListContainer.completedTasks}",
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
                    bloc.state.showCompleted
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  color: ToDoListTheme.mainScreenEyeColor,
                  splashColor: Colors.transparent,
                  onPressed: () => bloc.add(MainScreenSwitchCompleted()),
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
    final bloc = context.watch<MainScreenBloc>();
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
                children: bloc.state.taskListContainer.tasks,
              ),
              TextButton(
                onPressed: () => _openTaskForm(bloc),
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

  Future<void> _openTaskForm(MainScreenBloc bloc) async {
    bool? update = await NavigationManager.instance.openTaskForm();
    if (update != null && update) {
      bloc.add(MainScreenTaskListUpdate());
    }
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
    final bloc = context.watch<MainScreenBloc>();
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
                bloc.state.showCompleted
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              color: ToDoListTheme.mainScreenEyeColor,
              splashColor: Colors.transparent,
              onPressed: appear(shrinkOffset) == 1
                  ? () => bloc.add(
                      MainScreenSwitchCompleted()) // model.changeTaskList(BuildAppBar)
                  : () {},
            ),
          ),
        ],
      ),
    );
  }
}
