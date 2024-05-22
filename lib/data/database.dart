import 'package:hive/hive.dart';

class ToDoDatabase {
  final _myBox = Hive.box("mybox");

  List toDoList = [];

  void createInitialData() {
    toDoList = [
      ["Make tutorial", false],
      ["Do Exercise", false]
    ];
  }

  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateData() {
    _myBox.put("TODOLIST", toDoList);
  }
}
