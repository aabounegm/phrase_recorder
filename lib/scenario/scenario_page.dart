import 'package:flutter/material.dart';
import 'package:phrase_recorder/scenario/choice/choice_card.dart';
import 'package:phrase_recorder/scenario/choice/choice_exercise.dart';
import 'package:phrase_recorder/scenario/transition.dart';
import 'node/node.dart';
import 'node/node_card.dart';
import 'scenario.dart';

class ScenarioPage extends StatefulWidget {
  @override
  _ScenarioPageState createState() => _ScenarioPageState();
}

class _ScenarioPageState extends State<ScenarioPage> {
  final scenario = Scenario(
    {
      'start': Node(
        text: 'You enter the shop.',
        question: 'What do you need to buy?',
        type: 'choice',
        exercise: ChoiceExercise(
          options: [
            ChoiceOption('milk', 'Milk'),
            ChoiceOption('bread', 'Bread'),
            ChoiceOption('onion', 'Onion'),
          ],
        ),
        state: 'product',
        transitions: [
          Transition('end', check: 'product', value: 'milk'),
          Transition('bread', check: 'product', value: 'bread'),
          Transition('lose', check: 'product', value: 'onion'),
        ],
      ),
      'bread': Node(
        text: 'You are buying bread.',
        question: 'Which type do you want?',
        type: 'choice',
        exercise: ChoiceExercise(
          options: [
            ChoiceOption('white', 'White'),
            ChoiceOption('brown', 'Brown'),
          ],
        ),
        state: 'bread',
        transitions: [
          Transition('whiteBread', check: 'bread', value: 'white', score: 1),
          Transition('brownBread', check: 'bread', value: 'brown'),
        ],
      ),
      'whiteBread': Node(
        text: 'You bought white bread.',
        transitions: [
          Transition('end'),
        ],
      ),
      'brownBread': Node(
        text: 'You bought brown bread.',
        transitions: [
          Transition('end'),
        ],
      ),
      'end': Node(
        text: 'Nice.',
        outcome: 'win',
      ),
      'lose': Node(
        text: "You don't need onion.",
        outcome: 'loss',
      ),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: ListView(
        children: [
          for (final n in scenario.progress)
            NodeCard(
              node: n,
              onDone: scenario.node == n && scenario.ready
                  ? () => setState(() => scenario.moveNext())
                  : null,
              child: n.exercise == null
                  ? null
                  : ChoiceCard(
                      n.exercise,
                      onChanged: scenario.node == n && n.state != null
                          ? (s) => setState(() => scenario.setState(s))
                          : null,
                    ),
            ),
          if (scenario.finished) ...[
            Center(
              child: Text(
                scenario.node.outcome == 'win'
                    ? 'Score: ${scenario.score}'
                    : 'End',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScenarioPage(),
                  ),
                ),
                icon: Icon(Icons.restart_alt_outlined),
                label: Text('Restart'),
              ),
            )
          ],
        ],
      ),
    );
  }
}
