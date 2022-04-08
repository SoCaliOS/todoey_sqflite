class Task {
  final String name;
  bool isDone;

  Task({this.name, this.isDone = false});
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
