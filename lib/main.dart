import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phrase_recorder/chapters/chapters_list.dart';
import 'package:phrase_recorder/phrases/phrase_list.dart';
import 'package:phrase_recorder/scenario/scenario_page.dart';

import 'scenario/exercises/option.dart';
import 'scenario/node/node.dart';
import 'scenario/scenario.dart';
import 'scenario/transition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PhrasesApp());
}

class PhrasesApp extends StatelessWidget {
  final Future initializer = Firebase.initializeApp();
  final scenario = Scenario(
    nodes: [
      Node(
        id: 'start',
        text: 'You enter the shop.',
        question: 'What do you need to buy?',
        // type: 'typing',
        // exercise: 'I want to buy a pack of ### and a loaf of ###.',
        type: 'choice',
        exercise: [
          Option('milk', 'A pack of milk.'),
          Option('bread', 'A leaf of bread.'),
          Option('onion', 'Two kilos of onion.'),
        ],
        state: 'product',
        transitions: [
          Transition(
            'win',
            check: 'product',
            value: 'milk,bread',
          ),
          Transition(
            'partial',
            check: 'product',
            filter: 'contains',
            value: 'bread',
            score: -1,
          ),
          Transition('loss', check: 'product', value: 'onion'),
          Transition('miss'),
        ],
      ),
      Node(
        id: 'win',
        text: 'Nice.',
        outcome: 'win',
      ),
      Node(
        id: 'partial',
        text: "You missed something, but it's okay.",
        outcome: 'win',
      ),
      Node(
        id: 'miss',
        text: 'You missed something.',
        outcome: 'loss',
      ),
      Node(
        id: 'loss',
        text: 'Wrong answer.',
        outcome: 'loss',
      ),
    ],
    score: 1,
  );

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
          home: ChapterListScreen(),
        );
      },
    );
  }
}
