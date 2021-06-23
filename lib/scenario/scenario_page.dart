import 'package:flutter/material.dart';
import 'package:phrase_recorder/scenario/exercises/typing_exercise.dart';
import 'exercises/choice_exercise.dart';
import 'exercises/order_exercise.dart';
import 'exercises/multichoice_exercise.dart';
import 'exercises/option.dart';
import 'node/node.dart';
import 'node/node_card.dart';
import 'scenario.dart';
import 'transition.dart';

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
        type: 'typing',
        exercise: 'I want to buy a pack of ### and a load of ###.',
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
                  : Builder(builder: (_) {
                      if (n.type == 'choice') {
                        return ChoiceExercise(
                          n.exercise,
                          state: scenario.state[n.state]!,
                          onChanged:
                              scenario.node == n ? () => setState(() {}) : null,
                        );
                      }
                      if (n.type == 'multichoice') {
                        return MultichoiceExercise(
                          n.exercise,
                          state: scenario.state[n.state]!,
                          onChanged:
                              scenario.node == n ? () => setState(() {}) : null,
                        );
                      }
                      if (n.type == 'typing') {
                        return TypingExercise(
                          n.exercise,
                          state: scenario.state[n.state]!,
                          onChanged:
                              scenario.node == n ? () => setState(() {}) : null,
                        );
                      }
                      if (n.type == 'order') {
                        return OrderExercise(
                          n.exercise,
                          state: scenario.state[n.state]!,
                          onChanged:
                              scenario.node == n ? () => setState(() {}) : null,
                        );
                      }
                      return Offstage();
                    }),
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
