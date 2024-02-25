import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class TodoDatase extends ChangeNotifier {
  static late Isar isar;
  List<Todo> _todos = [];

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([TodoSchema], directory: dir.path);
  }

  List<Todo> get todos => _todos;

  Future<void> createNewTodo(Todo todo) async {
    await isar.writeTxn(() => isar.todos.put(todo));
    await loadTodos();
  }

  Future<void> updateTodo(int id, Todo updatedTodo) async {
    updatedTodo.id = id;
    await isar.writeTxn(() => isar.todos.put(updatedTodo));
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await isar.writeTxn(() => isar.todos.delete(id));
    await loadTodos();
  }

  Future<void> loadTodos() async {
    List<Todo> fetchedTodos = await isar.todos.where().findAll();

    _todos.clear();
    _todos.addAll(fetchedTodos);
    notifyListeners();
  }
}
