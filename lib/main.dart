import 'package:flutter/material.dart';
import 'home.dart';
import 'styles.dart';
import 'edit.dart' as edit;
import 'add.dart' as add;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe',
      theme: ThemeData(
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (_) => edit.EditScreen(
              id: args['id'] ?? '',
              initialTitle: args['initialTitle'] ?? '',
              initialNote: args['initialNote'] ?? '',
            ),
          );
        }

        if (settings.name == '/add') {
          return MaterialPageRoute(builder: (_) => const add.AddScreen());
        }

        return null;
      },
    );
  }
}
