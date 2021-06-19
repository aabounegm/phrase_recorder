import 'package:flutter/material.dart';
import 'package:phrase_recorder/exercises/choice/choice_card_widget.dart';
import 'exercises/scenario.dart';

class ExercisesPage extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final state = <String, String>{};
  final scenario = Scenario({
    'start': ScenarioNode(
      ChoiceExerciseData(
        'You enter the shop.',
        question: 'What do you need to buy?',
        options: {
          'milk': 'Milk',
          'bread': 'Bread',
          'onion': 'Onion',
        },
      ),
      result: 'product',
      transitions: [
        Transition(
          'end',
          valueKey: 'product',
          check: 'milk',
        ),
        Transition(
          'bread',
          valueKey: 'product',
          check: 'bread',
        ),
        Transition(
          'onion',
          valueKey: 'product',
          check: 'lose',
        ),
      ],
    ),
    'bread': ScenarioNode(
      ChoiceExerciseData(
        'You are buying bread.',
        question: 'Which type do you want?',
        options: {
          'white': 'White',
          'brown': 'Brown',
        },
        multichoice: true,
      ),
      result: 'bread',
      transitions: [
        Transition(
          'whiteBread',
          valueKey: 'bread',
          check: 'white',
          condition: TransitionCondition.Contains,
        ),
        Transition(
          'brownBread',
          valueKey: 'bread',
          check: 'brown',
          condition: TransitionCondition.Contains,
        ),
      ],
    ),
    'whiteBread': ScenarioNode(
      ChoiceExerciseData('You bought white bread.'),
      transitions: [Transition('end')],
    ),
    'brownBread': ScenarioNode(
      ChoiceExerciseData('You bought brown bread.'),
      transitions: [Transition('end')],
    ),
    'end': ScenarioNode(
      ChoiceExerciseData('Nice.'),
    ),
    'lose': ScenarioNode(
      ChoiceExerciseData('You lost.'),
    ),
  });

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
            ChoiceExercise(
              n.exercise,
              onDone: scenario.node == n
                  ? (s) {
                      if (n.result != null) state[n.result!] = s.join(', ');
                      final next = n.nextNode(state);
                      scenario.current = next;
                      if (scenario.node != null) progress.add(scenario.node!);
                      setState(() {});
                    }
                  : null,
            ),
        ],
      ),
    );
  }
}
