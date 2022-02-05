import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/widgets/tasks_list.dart';
import 'add_task_screen.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[700],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddTaskScreen(),
          );
        },
        child: const Icon(Icons.task_alt_rounded),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Stack(
              children: [
                Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: Icon(
                          Icons.playlist_add_check_rounded,
                          color: Colors.amber[700],
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Taskaty',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ValueListenableBuilder(
                valueListenable: Hive.box('Tasks').listenable(),
                child: Expanded(
                  child: TasksList(),
                ),
                builder: (context, Box box, widget) => box.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber[700],
                            size: MediaQuery.of(context).size.height * 0.2,
                          ),
                          Text(
                            'No Tasks',
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize: 30.0,
                            ),
                          ),
                          Text(
                            'Start add some..',
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize: 16.0,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 40.0,
                              right: 40.0,
                              bottom: 20,
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: '${box.length} ',
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: box.length > 1 ? 'Tasks' : 'Task',
                                    style: TextStyle(
                                      color: Colors.amber[700],
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          widget,
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
