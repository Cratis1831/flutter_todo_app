import 'package:isar/isar.dart';

// dart run build_runner build
part 'todo.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement;
  final String title;
  final String content;
  final bool isCompleted;

  Todo({
    required this.title,
    required this.content,
    this.isCompleted = false,
  });

  Todo copyWith({bool? isCompleted}) {
    return Todo(
      title: title,
      content: content,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
