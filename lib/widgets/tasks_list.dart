import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/models/task_data.dart';
import '../models/task.dart';
import '../screens/add_task_screen.dart';
import 'tasks_tile.dart';

class TasksList extends StatelessWidget {
  Future<bool> taskDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          title: const Text(
            'Delete Task?',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: const Text('Confirm that you want to delete task.'),
          actions: [
            MaterialButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.amber[700],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final SlidableController slidableController = SlidableController();
    return Consumer(
      builder: (context, watch, child) {
        final getTaskData = watch(taskData);
        return ValueListenableBuilder(
          valueListenable: Hive.box('Tasks').listenable(),
          builder: (context, box, widget) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final task = box.getAt(index) as Task;
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 1.0,
                        offset: Offset.fromDirection(90),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Slidable(
                      actionPane: const SlidableStrechActionPane(),
                      key: UniqueKey(),
                      controller: slidableController,
                      actionExtentRatio: 0.2,
                      dismissal: SlidableDismissal(
                        dismissThresholds: const <SlideActionType, double>{
                          SlideActionType.secondary: 1.0,
                          SlideActionType.primary: 0.2,
                        },
                        closeOnCanceled: true,
                        onWillDismiss: (actionType) =>
                            taskDeleteDialog(context),
                        onDismissed: (actionType) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task deleted successfully..'),
                            ),
                          );
                          getTaskData.deleteTask(task, index);
                        },
                        child: const SlidableDrawerDismissal(),
                      ),
                      actions: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return OverflowBox(
                              alignment: Alignment.centerLeft,
                              minWidth: constraints.minWidth,
                              maxWidth: constraints.maxWidth + 30.0,
                              minHeight: constraints.minHeight,
                              maxHeight: constraints.maxHeight,
                              child: IconSlideAction(
                                icon: Icons.delete,
                                color: Colors.red,
                                caption: 'Delete',
                                onTap: () =>
                                    slidableController.activeState.dismiss(),
                              ),
                            );
                          },
                        ),
                      ],
                      secondaryActions: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return OverflowBox(
                              alignment: Alignment.centerRight,
                              minWidth: constraints.minWidth,
                              maxWidth: constraints.maxWidth + 30.0,
                              minHeight: constraints.minHeight,
                              maxHeight: constraints.maxHeight,
                              child: IconSlideAction(
                                icon: Icons.edit,
                                color: Colors.green,
                                caption: 'Edit',
                                onTap: () => showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(40.0),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) => AddTaskScreen(
                                    editMode: true,
                                    task: task,
                                    index: index,
                                  ),
                                  isScrollControlled: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: TaskTile(
                            task: task,
                            isChecked: task.isPressed,
                            checkboxCallBack: (bool checkboxState) {
                              getTaskData.updateTask(task, index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: box.length as int,
            );
          },
        );
      },
    );
  }
}
