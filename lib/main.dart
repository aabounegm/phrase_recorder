import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phrase_recorder/chapters/chapters_list.dart';
import 'package:phrase_recorder/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PhrasesApp());
}

class PhrasesApp extends StatelessWidget {
  final initializer = Firebase.initializeApp();

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
          home: FirebaseAuth.instance.currentUser == null
              ? LoginScreen()
              : ChapterListScreen(),
        );
      },
    );
  }
}
