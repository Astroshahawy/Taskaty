import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'task.dart';

final taskData = ChangeNotifierProvider<TaskData>((ref) => TaskData());

class TaskData extends ChangeNotifier {
  Future<void> addTask(String taskName) async {
    if (taskName == null || taskName.trim().isEmpty) {
      return;
    }
    final newTask = Task(name: taskName.trim(), time: DateTime.now());
    final taskBox = Hive.box('Tasks');
    await taskBox.add(newTask);
    notifyListeners();
  }

  Future<void> editTask(Task task, int index, String edittedValue) async {
    final edittedTask = Task(
      name: edittedValue == null || edittedValue.trim().isEmpty
          ? task.name
          : edittedValue.trim(),
      isPressed: task.isPressed,
      time: DateTime.now(),
    );
    final taskBox = Hive.box('Tasks');
    await taskBox.putAt(index, edittedTask);
    notifyListeners();
  }

  Future<void> updateTask(Task task, int index) async {
    task.togglePress();
    final taskBox = Hive.box('Tasks');
    await taskBox.putAt(index, task);
    notifyListeners();
  }

  Future<void> deleteTask(Task task, int index) async {
    final taskBox = Hive.box('Tasks');
    await taskBox.deleteAt(index);
    notifyListeners();
  }
}
