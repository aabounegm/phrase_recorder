import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phrase_recorder/scenario/scenario_page.dart';

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
    {
      'start': Node(
        text: 'You enter the shop.',
        question: 'What do you need to buy?',
        type: 'typing',
        exercise: 'I want to buy a pack of ### and a loaf of ###.',
        // type: 'choice',
        // exercise: [
        //   Option('milk', 'A pack of milk.'),
        //   Option('bread', 'A leaf of bread.'),
        //   Option('onion', 'Two kilos of onion.'),
        // ],
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
      'win': Node(
        text: 'Nice.',
        outcome: 'win',
      ),
      'partial': Node(
        text: "You missed something, but it's okay.",
        outcome: 'win',
      ),
      'miss': Node(
        text: 'You missed something.',
        outcome: 'loss',
      ),
      'loss': Node(
        text: 'Wrong answer.',
        outcome: 'loss',
      ),
    },
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
          home: ScenarioPage(scenario),
        );
      },
    );
  }
}
