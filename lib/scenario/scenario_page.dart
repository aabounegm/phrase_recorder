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
    if (scenario != null) await reload(scenario);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              scenario == null
                  ? Icons.content_paste_off_outlined
                  : Icons.content_paste_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 16),
            Text(
              scenario == null
                  ? 'Error during JSON parsing.'
                  : 'Succesfully loaded Scenario.',
            ),
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
