import 'package:flutter/material.dart';
import 'package:phrase_recorder/firebase_builder.dart';
import 'package:phrase_recorder/screens/PhraseList.dart';
import 'package:phrase_recorder/store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PhrasesApp());
}

class PhrasesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      home: FirebaseBuilder(
        future: loadPhrases(),
        builder: () => PhraseListScreen(
          phrases,
          directory: recsDir,
        ),
      ),
    );
  }
}
