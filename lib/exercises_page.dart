import 'package:flutter/material.dart';
import 'package:phrase_recorder/exercises/choice/choice_card_widget.dart';
import 'package:phrase_recorder/exercises/choice/choice_exercise.dart';
import 'package:phrase_recorder/exercises/scenario_node.dart';
import 'package:phrase_recorder/exercises/scenario_node_card.dart';
import 'package:phrase_recorder/exercises/transition.dart';
import 'exercises/scenario.dart';

class ExercisesPage extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final scenario = Scenario(
    {
      'start': ScenarioNode(
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
      'bread': ScenarioNode(
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
          Transition('whiteBread', check: 'bread', value: 'white'),
          Transition('brownBread', check: 'bread', value: 'brown'),
        ],
      ),
      'whiteBread': ScenarioNode(
        text: 'You bought white bread.',
        transitions: [
          Transition('end'),
        ],
      ),
      'brownBread': ScenarioNode(
        text: 'You bought brown bread.',
        transitions: [
          Transition('end'),
        ],
      ),
      'end': ScenarioNode(
        text: 'Nice.',
      ),
      'lose': ScenarioNode(
        text: 'You lost.',
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
            ScenarioNodeCard(
              node: n,
              onDone: scenario.node == n && scenario.isReady
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
            )
        ],
      ),
    );
  }
}
