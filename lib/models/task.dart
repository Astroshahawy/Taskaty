import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  Task({
    @required this.name,
    this.isPressed = false,
    this.time,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  bool isPressed;

  @HiveField(2)
  DateTime time;

  void togglePress() {
    isPressed = !isPressed;
  }
}
