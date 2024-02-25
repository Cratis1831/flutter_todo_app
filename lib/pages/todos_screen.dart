import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:provider/provider.dart';

import '../widgets/todo_list_tile.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late Future<void> loadCompletedTodosFuture;
  late Future<void> loadIncompletedTodosFuture;

  @override
  void initState() {
    super.initState();
    loadCompletedTodosFuture = Provider.of<TodoDatabase>(context, listen: false).loadCompletedTodos();
    loadIncompletedTodosFuture = Provider.of<TodoDatabase>(context, listen: false).loadIncompletedTodos();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void openCreateTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: titleController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
                controller: contentController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: titleController.text.isEmpty || contentController.text.isEmpty
                  ? null
                  : () async {
                      Navigator.of(context).pop();
                      Todo newTodo = Todo(
                        title: titleController.text,
                        content: contentController.text,
                      );
                      await context.read<TodoDatabase>().createNewTodo(newTodo);
                      titleController.clear();
                      contentController.clear();
                    },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoDatabase>(
      builder: (context, todoDatabase, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: openCreateTodoDialog,
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text('Todos'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  height: 300,
                  child: FutureBuilder(
                    future: loadIncompletedTodosFuture,
                    builder: (context, builder) {
                      return ListView.builder(
                        itemCount: todoDatabase.incompletedTodos.length,
                        itemBuilder: (context, index) {
                          Todo todo = todoDatabase.incompletedTodos[index];
                          return TodoListTile(
                            todo: todo,
                            onChanged: (isCompleted) {
                              todoDatabase.updateTodo(
                                todo.id,
                                todo.copyWith(isCompleted: isCompleted),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 300,
                  child: FutureBuilder(
                    future: loadCompletedTodosFuture,
                    builder: (context, builder) {
                      return ListView.builder(
                        itemCount: todoDatabase.completedTodos.length,
                        itemBuilder: (context, index) {
                          Todo todo = todoDatabase.completedTodos[index];
                          return TodoListTile(
                            todo: todo,
                            onChanged: (isCompleted) {
                              todoDatabase.updateTodo(
                                todo.id,
                                todo.copyWith(isCompleted: isCompleted),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
