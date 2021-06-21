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
  final state = <String, Set<String>>{};
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
          multichoice: true,
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

  final List<ScenarioNode> progress = [];

  @override
  void initState() {
    super.initState();
    if (scenario.node != null) progress.add(scenario.node!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: ListView(
        children: [
          for (final n in progress)
            ScenarioNodeCard(
              node: n,
              onDone: scenario.node == n &&
                      (state[n.state ?? '']?.isNotEmpty ?? false)
                  ? () {
                      final next = n.nextNode(state);
                      scenario.current = next;
                      if (scenario.node != null) {
                        progress.add(scenario.node!);
                      }
                      setState(() {});
                    }
                  : null,
              child: ChoiceCard(
                n.exercise,
                onChanged: scenario.node == n && n.state != null
                    ? (s) {
                        if (s == null) {
                          state[n.state!]?.clear();
                        } else {
                          state[n.state!] = s;
                        }
                        setState(() {});
                      }
                    : null,
              ),
            )
        ],
      ),
    );
  }
}
