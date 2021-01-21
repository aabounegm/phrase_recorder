import 'package:flutter/material.dart';
import 'package:phrase_recorder/router.dart';

void main() {
  runApp(PhrasesApp());
}

class PhrasesApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhrasesAppState();
}

class _PhrasesAppState extends State<PhrasesApp> {
  final _routerDelegate = PhraseRouterDelegate();
  final _routeInformationParser = PhraseRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Phrases App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
