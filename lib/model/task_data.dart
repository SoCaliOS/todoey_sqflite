import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoey_flutter/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class TaskData extends ChangeNotifier {
  List<Task> tasks = [];

  int get taskCount => tasks.length;

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    tasks.add(task);
    notifyListeners();
    writeTextString();
//    setPref();
  }

  void updateTask(Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
    writeTextString();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
    writeTextString();
  }

  void getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedList = (prefs.getString('saveList') ??
        '[{"name":"rise and shine","isDone":false}]');
    createList(savedList);
    notifyListeners();
  }

  void createList(String text) {
    List<TaskItem> jsonList = [];
    jsonList =
        (json.decode(text) as List).map((i) => TaskItem.fromJson(i)).toList();

    tasks = [];
    for (int i = 0; i < jsonList.length; i++) {
      final task = Task(name: jsonList[i].name, isDone: jsonList[i].isDone);
      tasks.add(task);
    }
  }

  void setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedList = createJsonText();
    await prefs.setString('saveList', savedList);
    notifyListeners();
  }

  String createJsonText() {
    List<TaskItem> jsonList = [];
    for (int i = 0; i < tasks.length; i++) {
      final task = TaskItem(name: tasks[i].name, isDone: tasks[i].isDone);
      jsonList.add(task);
    }
    String savedList = jsonEncode(jsonList);
    return savedList;
  }

  void readTextString() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/myToDoList.txt');
      final String savedList = await file.readAsString();
      createList(savedList);
      print(savedList);
    } catch (e) {
      String savedList = '[{"name":"get up and boogie","isDone":false}]';
      print('cannot read file');
      createList(savedList);
    }
    notifyListeners();
  }

  void writeTextString() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/myToDoList.txt');
      final String savedList = createJsonText();
      await file.writeAsString(savedList);
      print('saved');
    } catch (e) {
      print('cannot save file');
    }
  }
}
