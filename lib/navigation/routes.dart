import 'package:flutter/material.dart';
import 'package:todo_list_school/logging/logging.dart';

import 'package:todo_list_school/ui/localization/s.dart';
import 'package:todo_list_school/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:todo_list_school/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_list_school/ui/widgets/task_row/task_row_widget.dart';

abstract class RouteNames {
  const RouteNames._();

  static const initialRoute = home;

  static const home = '/';
  static const taskForm = '/taskform';
}

abstract class RoutesBuilder {
  static final log = logger(RoutesBuilder);
  RoutesBuilder._();

  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const MainScreenWidget(),
          settings: settings,
        );

      case RouteNames.taskForm:
        return MaterialPageRoute<bool?>(
          builder: (_) => TaskFormWidget(
            config: settings.arguments as TaskWidgetConfiguration?,
          ),
          settings: settings,
        );
    }

    return null;
  }

  static Route<Object?>? onUnknownRoute<T>(RouteSettings settings) {
    return MaterialPageRoute<T>(
      builder: (context) => UnknownPage(
        routeName: settings.name,
      ),
      settings: settings,
    );
  }

  static List<Route<Object?>> onGenerateInitialRoutes(String initialRoutes) {
    final routes = <Route>[];

    if (initialRoutes.isEmpty || !initialRoutes.startsWith('/')) {
      log.e('invalid initialRoutes ($initialRoutes)');
    } else {
      final names = initialRoutes.substring(1).split('/');
      for (final name in names) {
        final route = onGenerateRoute(
          RouteSettings(name: '/$name'),
        );
        if (route != null) {
          routes.add(route);
        } else {
          routes.clear();
          break;
        }
      }
    }

    if (routes.isEmpty) {
      log.w('generated empty initial routes ($initialRoutes)');
      routes.add(
        onGenerateRoute(const RouteSettings(name: RouteNames.home))!,
      );
    }

    return routes;
  }
}

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key, required this.routeName});

  final String? routeName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(S.of(context).get('errorPage')),
      ),
    );
  }
}
