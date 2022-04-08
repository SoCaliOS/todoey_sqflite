import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:todoey_flutter/user_settings.dart';
import 'package:todoey_flutter/widgets/tasks_list.dart';
import 'package:todoey_flutter/screens/add_task_screen.dart';
import 'package:todoey_flutter/model/task_data.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/print_pdf.dart';

int _index = 3;

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    getPref();
    super.initState();
  }

  void getPref() async {
    setState(() {
      Provider.of<TaskData>(context, listen: false).listDatabaseItems();
      Provider.of<TaskData>(context, listen: false).getSharedPreferences();
      Provider.of<TaskData>(context, listen: false).getUserColor();
      Provider.of<TaskData>(context, listen: false).getUserMargins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: currentColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      titleLabel,
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '${Provider.of<TaskData>(context).taskCount} $taskLabel',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
//                    bottomLeft: Radius.circular(20.0),
//                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: TasksList(),
              ),
            ),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: currentColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(.60),
              selectedFontSize: 2,
              unselectedFontSize: 2,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (newIndex) async {
                setState(() {
                  _index = newIndex;
                });
                switch (_index) {
                  case 0:
                    printMethod = 'direct';
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PrintPreview('Print Preview');
                        },
                      ),
                    );
                    setState(() {
                      _index = 3;
                    });
                    print('print selected');
                    break;
                  case 1:
                    printMethod = 'share';
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PrintPreview('Share Preview');
                        },
                      ),
                    );
                    setState(() {
                      _index = 3;
                    });
                    print('share selected');
                    break;
                  case 2:
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UserSettings();
                        },
                      ),
                    );
                    setState(() {
                      _index = 3;
                    });
                    print('setup selected');
                    break;
                  case 3:
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddTaskScreen(),
                      ),
                    );
                    setState(() {
                      //
                    });
                    print('add selected');
                    break;
                }
              },
              currentIndex: _index,
              items: [
                BottomNavigationBarItem(
                  label: 'print',
                  icon: Icon(
                    Icons.print,
                    size: 25.0,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'share',
                  icon: Icon(
                    Icons.share,
                    size: 25.0,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'setup',
                  icon: Icon(
                    Icons.settings,
                    size: 25.0,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'add',
                  icon: AvatarGlow(
                    glowColor: Colors.white,
                    endRadius: 28.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Material(
//                      elevation: 6.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: currentColor,
                        child: Icon(
                          Icons.add,
                          size: 25.0,
                        ),
                        radius: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            )
//            SizedBox(height: 90.0),
          ],
        ));
  }
}
