import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    super.key,
    required this.todo,
    this.onChanged,
  });

  final Todo todo;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      subtitle: Text(todo.content),
      trailing: Checkbox(
        value: todo.isCompleted,
        onChanged: onChanged,
      ),
    );
  }
}
