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
  late Future<void> loadTodosFuture;
  bool showCompleted = false;

  @override
  void initState() {
    super.initState();
    loadTodosFuture = Provider.of<TodoDatabase>(context, listen: false).loadTodos();
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
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'Title', border: OutlineInputBorder()),
                  controller: titleController,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(hintText: 'Content', border: OutlineInputBorder()),
                  controller: contentController,
                  maxLines: 6,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
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
            actions: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    showCompleted = !showCompleted;
                  });
                  await todoDatabase.loadTodos(filterCompleted: showCompleted);
                },
                icon: const Icon(Icons.done_all),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 300,
                      child: FutureBuilder(
                        future: loadTodosFuture,
                        builder: (context, builder) {
                          if (builder.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (builder.hasError) {
                            return const Center(child: Text('An error occurred'));
                          }
                          if (todoDatabase.todos.isEmpty) {
                            return Center(
                              child: Text(
                                'No todos yet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: todoDatabase.todos.length,
                            itemBuilder: (context, index) {
                              Todo todo = todoDatabase.todos[index];
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
            ),
          ),
        );
      },
    );
  }
}
