import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:phrase_recorder/scenario/exercises/exercise_builder.dart';
import 'package:phrase_recorder/scenario/transition.dart';
import 'exercises/option.dart';
import 'node/node.dart';
import 'node/node_card.dart';
import 'scenario.dart';
import 'package:flutter/services.dart';

final defaultScenario = Scenario(
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

class ScenarioPage extends StatefulWidget {
  final Scenario scenario;

  ScenarioPage(this.scenario);

  @override
  _ScenarioPageState createState() => _ScenarioPageState();
}

class _ScenarioPageState extends State<ScenarioPage> {
  late final Scenario scenario;

  @override
  void initState() {
    super.initState();
    scenario = Scenario.fromJson(widget.scenario.toJson());
  }

  Future<void> reload(scenario) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScenarioPage(scenario),
      ),
    );
  }

  Future<void> serializeScenario() async {
    await Clipboard.setData(
      ClipboardData(
        text: jsonEncode(scenario.toJson()),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.content_copy_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 16),
            Text('Copied Scenario JSON to clipboard.'),
          ],
        ),
      ),
    );
  }

  Future<void> deserializeScenario() async {
    final textController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Paste Scenario JSON below'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: TextField(
                controller: textController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: TextButton.icon(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(Icons.code_outlined),
                  label: Text('Process Code')),
            ),
          ],
        );
      },
    );

    Scenario? scenario;
    try {
      scenario = Scenario.fromJson(
        jsonDecode(textController.text),
      );
    } catch (e) {
      scenario = null;
    }
    if (scenario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.content_paste_off_outlined,
                color: Colors.white,
              ),
              SizedBox(width: 16),
              Text('Error during JSON parsing.'),
            ],
          ),
        ),
      );
    } else {
      await reload(scenario);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
        actions: [
          IconButton(
            onPressed: deserializeScenario,
            icon: Icon(Icons.content_paste_outlined),
            tooltip: 'Load Scenario from JSON',
          ),
          IconButton(
            onPressed: serializeScenario,
            icon: Icon(Icons.content_copy_outlined),
            tooltip: 'Scenario to JSON',
          ),
          SizedBox(width: 4),
        ],
      ),
      body: ListView(
        children: [
          for (final n in scenario.progress)
            NodeCard(
              node: n,
              onDone: scenario.node == n && scenario.ready
                  ? () => setState(() => scenario.moveNext())
                  : null,
              child: n.exercise == null || n.state == null
                  ? null
                  : buildExercise(
                      type: n.type,
                      exercise: n.exercise,
                      state: scenario.state[n.state]!,
                      onChanged:
                          scenario.node == n ? () => setState(() {}) : null,
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
                onPressed: () => reload(widget.scenario),
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
