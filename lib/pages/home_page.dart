import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myBox = Hive.box("mybox");
  ToDoDatabase database = ToDoDatabase();

  final _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (myBox.get("TODOLIST") == null) {
      database.createInitialData();
    } else {
      database.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      database.toDoList[index][1] = !database.toDoList[index][1];
    });
    database.updateData();
  }

  void saveNewTask() {
    setState(() {
      database.toDoList.add([_controller.text, false]);
    });
    database.updateData();
    _controller.clear();
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      database.toDoList.removeAt(index);
    });
    database.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
            backgroundColor: Colors.yellow[300],
            elevation: 0,
            title: const Center(
              child: Text("To Do",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            )),
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              onPressed: createNewTask,
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ListView.builder(
            itemCount: database.toDoList.length,
            itemBuilder: (context, index) {
              return TodoTile(
                taskName: database.toDoList[index][0],
                taskCompleted: database.toDoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteTask: (context) => deleteTask(index),
              );
            },
          ),
        ));
  }
}
