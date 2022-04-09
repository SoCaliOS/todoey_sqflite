import 'package:flutter/material.dart';
import 'package:todoey_flutter/user_settings.dart';
import 'package:todoey_flutter/model/task_data.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final ValueChanged<bool?>? checkboxCallback;
  final GestureLongPressCallback longPressCallback;

  TaskTile(
      { required this.isChecked,
        required this.taskTitle,
        required this.checkboxCallback,
        required this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: Text(taskTitle,
          style: TextStyle(
            decoration: isChecked ? TextDecoration.lineThrough : null,
            fontSize: 20.0,
          )),
      trailing: Checkbox(
        activeColor: currentColor,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
    );
  }
}
