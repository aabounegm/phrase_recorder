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
    final textController = TextEditingController();
    textController.text = jsonEncode(scenario.toJson());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select assignment'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: TextField(
                controller: textController,
                readOnly: true,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: '',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: textController.text),
                      );
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.content_copy_outlined),
                    label: Text('COPY TO CLIPBOARD'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
            icon: Icon(Icons.code_outlined),
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
