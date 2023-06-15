import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todo_list_school/navigation/navigation.dart';
import 'package:todo_list_school/navigation/routes.dart';

import 'package:todo_list_school/ui/localization/s.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return MaterialApp(
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme:
          brightness == Brightness.light ? ThemeData.light() : ThemeData.dark(),
      restorationScopeId: 'app',
      navigatorKey: NavigationManager.instance.key,
      initialRoute: RouteNames.initialRoute,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      onUnknownRoute: RoutesBuilder.onUnknownRoute,
      onGenerateInitialRoutes: RoutesBuilder.onGenerateInitialRoutes,
      navigatorObservers: NavigationManager.instance.observers,
    );
  }
}
