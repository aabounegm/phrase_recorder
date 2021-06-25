import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:phrase_recorder/scenario/exercises/exercise_builder.dart';
import 'node/node_card.dart';
import 'scenario.dart';
import 'package:flutter/services.dart';

class ScenarioPage extends StatefulWidget {
  final Scenario scenario;

  ScenarioPage(this.scenario);

  @override
  _ScenarioPageState createState() => _ScenarioPageState();
}

class _ScenarioPageState extends State<ScenarioPage> {
  Scenario get scenario => widget.scenario;

  void reload(scenario) {
    Navigator.pushReplacement(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
        actions: [
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
              child: n.exercise == null
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
                onPressed: () => reload(scenario),
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
