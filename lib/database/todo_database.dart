import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class TodoDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Todo> _todos = [];
  final List<Todo> _completedTodos = [];
  final List<Todo> _incompletedTodos = [];

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([TodoSchema], directory: dir.path);
  }

  List<Todo> get completedTodos => _completedTodos;
  List<Todo> get incompletedTodos => _incompletedTodos;
  List<Todo> get todos => _todos;

  Future<void> createNewTodo(Todo todo) async {
    await isar.writeTxn(() => isar.todos.put(todo));
    await loadTodos();
  }

  Future<void> updateTodo(int id, Todo updatedTodo) async {
    updatedTodo.id = id;
    await isar.writeTxn(() => isar.todos.put(updatedTodo));
    await loadTodos();
    await loadCompletedTodos();
    await loadIncompletedTodos();
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

  Future<void> loadCompletedTodos() async {
    List<Todo> fetchedTodos = await isar.todos.where().filter().isCompletedEqualTo(true).findAll();

    _completedTodos.clear();
    _completedTodos.addAll(fetchedTodos);
    notifyListeners();
  }

  Future<void> loadIncompletedTodos() async {
    List<Todo> fetchedTodos = await isar.todos.where().filter().isCompletedEqualTo(false).findAll();

    _incompletedTodos.clear();
    _incompletedTodos.addAll(fetchedTodos);
    notifyListeners();
  }
}
