import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/todos_screen.dart';
import 'package:provider/provider.dart';

import 'database/todo_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TodoDatase.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoDatase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TodosScreen(),
    );
  }
}
