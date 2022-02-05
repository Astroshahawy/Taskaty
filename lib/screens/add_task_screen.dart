import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../models/task_data.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    Key key,
    this.editMode = false,
    this.task,
    this.index,
  }) : super(key: key);

  final bool editMode;
  final Task task;
  final int index;

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController controller;
  String newTaskTitle;
  @override
  Widget build(BuildContext context) {
    controller =
        TextEditingController(text: widget.editMode ? widget.task.name : '');
    controller.selection = widget.editMode
        ? TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          )
        : TextSelection.collapsed(offset: controller.text.length);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.editMode ? 'Edit Task' : 'Add Task',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.amber[700],
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 0.5,
                  offset: Offset.fromDirection(90),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: InputBorder.none,
                hintText: 'Enter a task..',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              cursorColor: Colors.amber[700],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
              ),
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MaterialButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  color: Colors.grey[400],
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Consumer(
                  builder: (context, watch, child) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: MaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        color: Colors.amber[700],
                        onPressed: () {
                          widget.editMode
                              ? context.read(taskData).editTask(
                                  widget.task, widget.index, newTaskTitle)
                              : context.read(taskData).addTask(newTaskTitle);
                          Navigator.pop(context);
                        },
                        child: Text(
                          widget.editMode ? 'Confirm' : 'Add',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
