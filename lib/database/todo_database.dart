import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class TodoDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Todo> _todos = [];

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

  Future<void> loadTodos({bool filterCompleted = false}) async {
    List<Todo> fetchedTodos;

    if (filterCompleted) {
      fetchedTodos = await isar.todos.where().filter().isCompletedEqualTo(!filterCompleted).sortByIsCompleted().thenByTitle().findAll();
    } else {
      fetchedTodos = await isar.todos.where().sortByIsCompleted().thenByTitle().findAll();
    }

    _todos.clear();
    _todos.addAll(fetchedTodos);
    notifyListeners();
  }
}
