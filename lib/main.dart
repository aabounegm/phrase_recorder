import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phrase_recorder/chapters/chapters_list.dart';

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
            cardTheme: CardTheme(
              clipBehavior: Clip.antiAlias,
            ),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.grey),
          ),
          home: ChapterListScreen(),
        );
      },
    );
  }
}
