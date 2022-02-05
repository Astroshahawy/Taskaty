import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    @required this.task,
    @required this.isChecked,
    @required this.checkboxCallBack,
  });

  final Function(bool) checkboxCallBack;
  final bool isChecked;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        task.name,
        style: TextStyle(
            fontSize: 16.0,
            decoration: isChecked ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(
        DateFormat('EEE   hh:mm a').format(task.time),
        style: const TextStyle(fontSize: 12.0),
      ),
      secondary: Icon(
        Icons.circle,
        color: isChecked ? null : Colors.amber[700],
      ),
      activeColor: Colors.amber[700],
      value: isChecked,
      onChanged: checkboxCallBack,
    );
  }
}
