import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:provider/provider.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Dismissible(
        onDismissed: (_) {
          Provider.of<TodoDatabase>(context, listen: false).deleteTodo(todo.id);
        },
        key: ValueKey(todo.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        child: ListTile(
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            todo.content,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Checkbox(
            value: todo.isCompleted,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
