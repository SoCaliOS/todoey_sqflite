import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/model/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? newTaskTitle;

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
                color: currentColor,
              ),
            ),
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: currentColor),
                ),
              ),
              onChanged: (newText) {
                newTaskTitle = newText.trim();
              },
              onSubmitted: (newText) {
                newTaskTitle = newText.trim();
                if (newTaskTitle != null && newTaskTitle!.length > 0) {
                  Provider.of<TaskData>(context, listen: false)
                      .addTask(newTaskTitle!);
                }
                Navigator.pop(context);
              },
            ),
            FlatButton(
              color: currentColor,
              onPressed: () {
                if (newTaskTitle != null) {
                  if (newTaskTitle!.trim().length > 0) {
                    Provider.of<TaskData>(context, listen: false)
                        .addTask(newTaskTitle!);
                  }
                }
                Navigator.pop(context);
              },
              child: Text(
                'Add',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
