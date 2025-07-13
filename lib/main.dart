import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'styles.dart';
import 'edit.dart' as edit;
import 'add.dart' as add;
import 'utils/theme-provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Safe',
      theme: ThemeData(
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.baiJamjureeTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: const Login(),
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
