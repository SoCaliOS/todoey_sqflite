import 'package:flutter/material.dart';
import 'package:todoey_flutter/model/task.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:todoey_flutter/model/page_sizes.dart';

String titleLabel = 'Hello';
String taskLabel = '';
String pageSize = '';
String printMethod = '';
String colorCode = '';
Color currentColor = Color(0xff3f7eb5);
String printAllItems = '';
String printTextColor = '';
double? left, top, right, bottom;
String fontSelected = '';

class TaskData extends ChangeNotifier {
  List<Task> tasks = [];
  List<Task> tasksUnchecked = [];

  int get taskCount => tasks.length;

  void addTask(String newTaskTitle) async {
    final task = Task(name: newTaskTitle);
    tasks.add(task);
    notifyListeners();

    // add taskItem to database
    var taskItem = TaskItem(name: task.name, isDone: task.isDone ? 1 : 0);
    await insertDatabaseItem(taskItem);
  }

  void updateTask(Task task) async {
    task.isDone = !task.isDone;
    notifyListeners();

    // update taskItem to database
    var taskItem = TaskItem(name: task.name, isDone: task.isDone ? 1 : 0);
    await updateDatabaseItem(taskItem);
  }

  void deleteTask(Task task) async {
    tasks.remove(task);
    notifyListeners();

    // update taskItem to database
    var taskItem = TaskItem(name: task.name, isDone: task.isDone ? 1 : 0);
    await deleteDatabaseItem(taskItem);
  }

  Future<List<TaskItem>> listDatabaseItems() async {
    // add spinner
    Database db = await initiateDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    final tasksDatabase = List.generate(
      maps.length,
      (i) {
        return TaskItem(
          name: maps[i]['name'],
          isDone: maps[i]['isDone'],
        );
      },
    );

    tasks = [];

    for (int i = 0; i < tasksDatabase.length; i++) {
      final task = Task(
        name: tasksDatabase[i].name,
        isDone: tasksDatabase[i].isDone == 0 ? (false) : (true),
      );
      tasks.add(task);
    }

    notifyListeners();
    return tasksDatabase;
  }

  Future<void> insertDatabaseItem(TaskItem taskItem) async {
    Database db = await initiateDatabase();
    await db.insert(
      'tasks',
      taskItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Database> initiateDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'todoey_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(name TEXT, isDone INTEGER)",
        );
      },
      version: 1,
    );
    final Database db = await database;
    return db;
  }

  Future getSharedPreferences() async {
    // get user preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPreference = (prefs.getString('userPreference') ??
        '{"titleName":"Today","taskName":"Tasks","pageSize":"4x6","printAllItems":"YES","fontSelected":"assets/ARIALUNI.TTF","printTextColor":"BLACK"}');
    Map<String, dynamic> map = jsonDecode(userPreference);
    titleLabel = map['titleName'];
    taskLabel = map['taskName'];
    pageSize = map['pageSize'];
    printAllItems = map['printAllItems'];
    fontSelected = map['fontSelected'];
    printTextColor = map['printTextColor'];
  }

  Future getUserColor() async {
    SharedPreferences prefsNew = await SharedPreferences.getInstance();
    try {
      currentColor = Color(prefsNew.getInt('color') ?? 0xff3f7eb5);
    } catch (e) {
      currentColor = Color(0xff3f7eb5);
    }
  }

  Future getUserMargins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      left = prefs.getDouble('left') ?? 0.0;
      top = prefs.getDouble('top') ?? 0.0;
      right = prefs.getDouble('right') ?? 0.0;
      bottom = prefs.getDouble('bottom') ?? 0.0;
    } catch (e) {
      left = top = right = bottom = 0.0;
    }
  }

  Future<void> updateDatabaseItem(TaskItem taskItem) async {
    Database db = await initiateDatabase();

    await db.update(
      'tasks',
      taskItem.toJson(),
      where: "name = ?",
      whereArgs: [taskItem.name],
    );
  }

  Future<void> deleteDatabaseItem(TaskItem taskItem) async {
    Database db = await initiateDatabase();

    await db.delete(
      'tasks',
      where: "name = ?",
      whereArgs: [taskItem.name],
    );
  }
}
