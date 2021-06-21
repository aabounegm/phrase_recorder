import 'package:flutter/material.dart';
import 'package:phrase_recorder/exercises/scenario_node.dart';

class ScenarioNodeCard extends StatefulWidget {
  final ScenarioNode node;
  final Function? onDone;
  final Widget? child;

  const ScenarioNodeCard({
    required this.node,
    required this.child,
    this.onDone,
  });

  @override
  _ScenarioNodeCardState createState() => _ScenarioNodeCardState();
}

class _ScenarioNodeCardState extends State<ScenarioNodeCard> {
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(widget.node.text),
                subtitle: widget.node.question == null
                    ? null
                    : Text(widget.node.question!),
              ),
              if (widget.child != null) widget.child!,
            ],
          ),
        ),
        widget.onDone == null || done
            ? Icon(
                Icons.expand_more_outlined,
                color: Colors.black45,
              )
            : IconButton(
                onPressed: () {
                  widget.onDone!();
                  setState(() {
                    done = true;
                  });
                },
                icon: Icon(Icons.done),
                iconSize: 32,
              ),
      ],
    );
  }
}
