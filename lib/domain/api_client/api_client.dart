import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todo_list_school/logging/logging.dart';
import 'package:todo_list_school/ui/widgets/task_form/date.dart';
import 'package:todo_list_school/ui/widgets/task_row/task_row_widget.dart';

class ApiClient {
  static const _token = 'preconvincing';
  static const _deviceId = "1";
  static int _revision = 5;

  final _dio = Dio(BaseOptions(baseUrl: 'https://beta.mrdekk.ru/todobackend'));

  Future<List<TaskWidget>> getTaskList() async {
    if (await checkInternet()) {
      final response = await _dio.get(
        '/list',
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
          },
        ),
      );
      if (response.data['status'] == 'ok') {
        _revision = response.data['revision'];
        List<dynamic> newList = response.data['list'];
        List<TaskWidget> taskList = [];
        for (int i = 0; i < newList.length; i++) {
          String? date;
          if (newList[i]['deadline'] != null) {
            final time =
                DateTime.fromMillisecondsSinceEpoch(newList[i]['deadline']);
            date = '${time.day} ${Date.getMonth(time.month)} ${time.year}';
          }
          TaskWidget item = TaskWidget(
            configuration: TaskWidgetConfiguration(
              id: int.parse(newList[i]['id']),
              isCompleted: newList[i]['done'],
              relevance: newList[i]['importance'] == 'basic'
                  ? Relevance.none
                  : newList[i]['importance'] == 'low'
                      ? Relevance.low
                      : Relevance.high,
              description: newList[i]['text'],
              date: date,
            ),
          );
          taskList.add(item);
        }
        return taskList;
      } else {
        final log = logger(ApiClient);
        log.e('get task list error');
        return [];
      }
    } else {
      return [];
    }
  }

  Future<void> postTask(TaskWidgetConfiguration config) async {
    if (await checkInternet()) {
      int? deadline;
      if (config.date != null) {
        final dateList = config.date!.split(' ').toList();
        final day = int.parse(dateList[0]);
        final month = Date.getNumber(dateList[1]);
        final year = int.parse(dateList[2]);
        deadline = DateTime(year, month, day).millisecondsSinceEpoch;
      }
      final map = {
        "element": {
          "id": config.id.toString(), // уникальный идентификатор элемента
          "text": config.description,
          "importance": config.relevance == Relevance.none
              ? "basic"
              : config.relevance == Relevance.low
                  ? "low"
                  : "important", // importance = low | basic | important
          "deadline": deadline, // int64, может отсутствовать, тогда нет
          "done": config.isCompleted,
          "color": null, // может отсутствовать
          "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          "last_updated_by": _deviceId,
        },
      };
      final response = await _dio.post(
        '/list',
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
            "X-Last-Known-Revision": _revision,
          },
        ),
        data: map,
      );
      _revision = response.data['revision'];
    }
  }

  Future<TaskWidgetConfiguration?> getTask(int id) async {
    if (await checkInternet()) {
      final response = await _dio.get(
        '/list/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
          },
        ),
      );
      if (response.data['status'] == 'ok') {
        _revision = response.data['revision'];
        String? date;
        if (response.data['deadline'] != null) {
          final time =
              DateTime.fromMillisecondsSinceEpoch(response.data['deadline']);
          date = '${time.day} ${Date.getMonth(time.month)} ${time.year}';
        }
        final config = TaskWidgetConfiguration(
          id: id,
          isCompleted: response.data['element']['done'],
          relevance: response.data['element']['importance'] == 'basic'
              ? Relevance.none
              : response.data['element']['importance'] == 'low'
                  ? Relevance.low
                  : Relevance.high,
          description: response.data['element']['text'],
          date: date,
        );
        return config;
      } else {
        final log = logger(ApiClient);
        log.e('get task error');
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> patchTaskList(List<TaskWidget> list) async {
    if (await checkInternet()) {
      final List<Map<String, Object?>> taskList = [];
      for (int i = 0; i < list.length; i++) {
        int? deadline;
        if (list[i].configuration.date != null) {
          final dateList = list[i].configuration.date!.split(' ').toList();
          final day = int.parse(dateList[0]);
          final month = Date.getNumber(dateList[1]);
          final year = int.parse(dateList[2]);
          deadline = DateTime(year, month, day).millisecondsSinceEpoch;
        }
        final map = {
          "id": list[i]
              .configuration
              .id
              .toString(), // уникальный идентификатор элемента
          "text": list[i].configuration.description,
          "importance": list[i].configuration.relevance == Relevance.none
              ? "basic"
              : list[i].configuration.relevance == Relevance.low
                  ? "low"
                  : "important", // importance = low | basic | important
          "deadline": deadline, // int64, может отсутствовать, тогда нет
          "done": list[i].configuration.isCompleted,
          "color": null, // может отсутствовать
          "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          "last_updated_by": _deviceId,
        };
        taskList.add(map);
      }
      final Map<String, Object?> input = {"list": taskList};
      final response = await _dio.patch(
        '/list',
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
            "X-Last-Known-Revision": _revision,
          },
        ),
        data: input,
      );
      _revision = response.data['revision'];
    }
  }

  Future<void> updateTask(TaskWidgetConfiguration config) async {
    if (await checkInternet()) {
      int? deadline;
      if (config.date != null) {
        final dateList = config.date!.split(' ').toList();
        final day = int.parse(dateList[0]);
        final month = Date.getNumber(dateList[1]);
        final year = int.parse(dateList[2]);
        deadline = DateTime(year, month, day).millisecondsSinceEpoch;
      }
      final map = {
        "element": {
          "id": config.id.toString(), // уникальный идентификатор элемента
          "text": config.description,
          "importance": config.relevance == Relevance.none
              ? "basic"
              : config.relevance == Relevance.low
                  ? "low"
                  : "important", // importance = low | basic | important
          "deadline": deadline, // int64, может отсутствовать, тогда нет
          "done": config.isCompleted,
          "color": null, // может отсутствовать
          "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
          "last_updated_by": _deviceId,
        },
      };
      final response = await _dio.put(
        '/list/${config.id}',
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
            "X-Last-Known-Revision": _revision,
          },
        ),
        data: map,
      );
      _revision = response.data['revision'];
    }
  }

  Future<void> deleteTask(int id) async {
    if (await checkInternet()) {
      final response = await _dio.delete(
        '/list/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
            "X-Last-Known-Revision": _revision,
          },
        ),
      );
      _revision = response.data['revision'];
    }
  }

  Future<bool> checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      return true;
    }
    return false;
  }
}
