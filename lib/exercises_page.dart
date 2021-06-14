import 'package:flutter/material.dart';
import 'package:phrase_recorder/exercises/choice_exercise.dart';

enum TransitionCondition { Equals, Contains }

class Transition {
  final String nodeId;
  final String? valueKey;
  final String? check;
  final TransitionCondition condition;

  Transition(
    this.nodeId, {
    this.valueKey,
    this.check,
    this.condition = TransitionCondition.Equals,
  });

  bool evaluate(Map<String, String> state) {
    final value = state[valueKey];
    if (value == null || check == null) return true;
    switch (condition) {
      case TransitionCondition.Equals:
        return value == check;
      case TransitionCondition.Contains:
        return value.contains(check!);
    }
  }
}

class ScenarioNode {
  final ChoiceExerciseData exercise;
  final String? result;
  final List<Transition>? transitions;

  const ScenarioNode(
    this.exercise, {
    this.result,
    this.transitions,
  });

  String nextNode(Map<String, String> state) {
    return transitions
            ?.firstWhere(
              (t) => t.evaluate(state),
              orElse: () => Transition(''),
            )
            .nodeId ??
        '';
  }
}

class Scenario {
  String current;
  final Map<String, ScenarioNode> nodes;

  ScenarioNode? get node => nodes[current];

  Scenario(
    this.nodes, {
    this.current = 'start',
  });
}

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
        'You enter the shop.',
        question: 'What do you need to buy?',
        options: {
          'white': 'White',
          'brown': 'Brown',
        },
      ),
      result: 'bread',
      transitions: [
        Transition('whiteBread'),
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
