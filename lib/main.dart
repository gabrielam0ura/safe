import 'package:flutter/material.dart';
import 'login.dart';
import 'styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário Pessoal',
      theme: ThemeData(
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
