import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:todoey_flutter/model/task_data.dart';

class PrintPreview extends StatelessWidget {
  const PrintPreview(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: currentColor,
          title: Text(title),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 30.0,
            ),
          ),
        ),
        body: PdfPreview(
          useActions: printMethod == 'both' ? true : false,
          canChangePageFormat: false,
          build: (format) => _generatePdf(format),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    List<Task> tasks = await listDatabaseItems();

    final fontUsed = pw.Font.ttf(await rootBundle.load(fontSelected));

    if (pageSize == '4x6') {
      format = PdfPageFormat(288.0, 432.0, marginAll: 28.0); //photo4x6
    } else if (pageSize == 'letter') {
      format = PdfPageFormat.letter;
    } else if (pageSize == 'roll57') {
      format = PdfPageFormat.roll57;
    } else if (pageSize == 'roll80') {
      format = PdfPageFormat.roll80;
    } else if (pageSize == 'label2.4') {
      format = PdfPageFormat(172.8, double.infinity, marginAll: 18.0); //dk2205
    } else if (pageSize == 'label2.3x3.4') {
      format = PdfPageFormat(165.6, 244.8, marginAll: 10.0); //dk1234
    } else if (pageSize == 'label2.4x4') {
      format = PdfPageFormat(172.8, 280.8, marginAll: 12.0); //dk1202
    } else if (pageSize == 'label2x4') {
      format = PdfPageFormat(144.0, 280.8, marginAll: 8.0); //die-cut 2x4
    } else if (pageSize == 'label4x3') {
      format = PdfPageFormat(280.8, 216.0, marginAll: 10.0); //rd rolls RDM05U1
    } else if (pageSize == 'a4') {
      format = PdfPageFormat.a4;
    } else if (pageSize == 'a6') {
      format = PdfPageFormat(295.2, 417.6, marginAll: 28.0);
    } else if (pageSize == 'a7') {
      format = PdfPageFormat(208.8, 295.2, marginAll: 18.0);
    } else if (pageSize == 'roll102') {
      format = PdfPageFormat(288.0, double.infinity,
          marginAll: 10.0); // set > 288 to print longer
    } else if (pageSize == 'banner') {
      format = PdfPageFormat(312.0, double.infinity, marginAll: 18.0);
    } else if (pageSize == '9mm') {
      format = PdfPageFormat(26.0, double.infinity, marginAll: 2.0);
    } else if (pageSize == '12mm') {
      format = PdfPageFormat(36.0, double.infinity, marginAll: 2.0);
    } else if (pageSize == '18mm') {
      format = PdfPageFormat(54.0, double.infinity, marginAll: 2.0);
    } else if (pageSize == '24mm') {
      format = PdfPageFormat(72.0, double.infinity, marginAll: 2.0);
    } else if (pageSize == '36mm') {
      format = PdfPageFormat(102.0, double.infinity, marginAll: 2.0);
    } else if (pageSize == 'roll54') {
      format =
          PdfPageFormat(151.2, double.infinity, marginAll: 2.0); // dkn-5224
    } else if (pageSize == '3x5') {
      format = PdfPageFormat(216, 360, marginAll: 12.0);
    } else if (pageSize == '5x8') {
      format = PdfPageFormat(360, 576, marginAll: 28.0);
    } else {
      // no change, keep as initial
    }

    print('$pageSize format = $format');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        orientation: pw.PageOrientation.portrait, // default
        build: (context) {
          return pw.Expanded(
            child: pw.ListView.separated(
              padding: pw.EdgeInsets.fromLTRB(left, top, right, bottom),
              itemCount: tasks.length,
              itemBuilder: (context, int index) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      '${tasks[index]}',
                      // to add number use -> '${index + 1}. ${tasks[index]}',
                      // to change default left alignment -> textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                        fontSize: 12.0, // default 16
                        font: fontUsed,
                        color: printTextColor == 'BLACK'
                            ? PdfColors.black
                            : PdfColors.red,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, int index) => pw.Divider(
                  thickness: 0.3,
                  height: 2.0, // default 15
                  color: PdfColors.black),
            ),
          );
        },
      ),
    );

    print(printMethod);

    if (printMethod == 'share') {
      await Printing.sharePdf(bytes: pdf.save());
    } else if (printMethod == 'direct') {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }

    return pdf.save();
  }
}

Future<List<Task>> listDatabaseItems() async {
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

  List<Task> tasks = [];
  List<Task> tasksUnchecked = [];
  for (int i = 0; i < tasksDatabase.length; i++) {
    final task = Task(
      name: tasksDatabase[i].name,
    );
    tasks.add(task);

    // unchecked Task
    if (tasksDatabase[i].isDone == 0) {
      final taskUnchecked = Task(
        name: tasksDatabase[i].name,
      );
      tasksUnchecked.add(taskUnchecked);
      print('${tasksDatabase[i].name} - ${tasksDatabase[i].isDone}');
    }
  }

  if (printAllItems == 'YES') {
    return tasks;
  } else {
    return tasksUnchecked;
  }
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

class Task {
  final String name;

  Task({this.name});

  @override
  String toString() {
    return '$name';
  }
}

class TaskItem {
  final String name;
  final dynamic isDone;

  TaskItem({this.name, this.isDone});

  TaskItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        isDone = json['isDone'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isDone': isDone,
    };
  }

  @override
  String toString() {
    return 'Todo $name, $isDone';
  }
}
