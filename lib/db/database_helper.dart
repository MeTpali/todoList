import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_school/ui/widgets/task_row/task_row_widget.dart';
// import 'package:flutter_app/models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._(); // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String taskTable = 'task_table';
  String id = 'id';
  String isCompleted = 'isCompleted';
  String description = 'description';
  String relevance = 'relevance';
  String date = 'date';

  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}tasks.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $taskTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $description TEXT, '
        '$relevance INTEGER, $isCompleted INTEGER, $date TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await database;

//		var result = await db.rawQuery('SELECT * FROM $taskTable order by $colPriority ASC');
    var result = await db.query(taskTable, orderBy: '$id ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertTask(TaskWidgetConfiguration task) async {
    Map<String, dynamic> map = {};
    map[description] = task.description;
    map[relevance] = task.relevance == Relevance.none
        ? 0
        : task.relevance == Relevance.low
            ? 1
            : 2;
    map[isCompleted] = task.isCompleted ? 1 : 0;
    if (task.date != null) {
      map[date] = task.date;
    }
    Database db = await database;
    var result = await db.insert(taskTable, map);
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateTask(TaskWidgetConfiguration task) async {
    Map<String, dynamic> map = {};
    map[id] = task.id;
    map[description] = task.description;
    map[relevance] = task.relevance == Relevance.none
        ? 0
        : task.relevance == Relevance.low
            ? 1
            : 2;
    map[isCompleted] = task.isCompleted ? 1 : 0;
    if (task.date != null) {
      map[date] = task.date;
    }
    var db = await database;
    var result = await db.update(
      taskTable,
      map,
      where: '$id = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteTask(int id) async {
    var db = await database;
    int result =
        await db.rawDelete('DELETE FROM $taskTable WHERE ${this.id} = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int?> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $taskTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<TaskWidget>> getTaskList() async {
    var taskMapList = await getTaskMapList(); // Get 'Map List' from database
    int count =
        taskMapList.length; // Count the number of map entries in db table

    List<TaskWidget> noteList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      TaskWidget curTask = TaskWidget(
        configuration: TaskWidgetConfiguration(
          id: taskMapList[i][id],
          isCompleted: taskMapList[i][isCompleted] == 1 ? true : false,
          relevance: taskMapList[i][relevance] == 0
              ? Relevance.none
              : taskMapList[i][relevance] == 1
                  ? Relevance.low
                  : Relevance.high,
          description: taskMapList[i][description],
          date: taskMapList[i][date],
        ),
      );
      noteList.add(curTask);
    }
    return noteList;
  }
}
