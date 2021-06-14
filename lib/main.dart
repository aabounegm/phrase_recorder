import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'exercises_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PhrasesApp());
}

class PhrasesApp extends StatelessWidget {
  final Future initializer = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializer,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Phrases App',
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.grey,
            cardTheme: CardTheme(
              clipBehavior: Clip.antiAlias,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.grey,
            cardTheme: CardTheme(
              clipBehavior: Clip.antiAlias,
            ),
          ),
          home: ExercisesPage(),
        );
      },
    );
  }
}
