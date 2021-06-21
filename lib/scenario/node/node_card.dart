import 'package:flutter/material.dart';
import 'node.dart';

class NodeCard extends StatelessWidget {
  final Node node;
  final Function()? onDone;
  final Widget? child;

  const NodeCard({
    required this.node,
    required this.child,
    this.onDone,
  });
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
                title: Text(node.text),
                subtitle: node.question == null ? null : Text(node.question!),
              ),
              if (child != null) child!,
            ],
          ),
        ),
        onDone == null
            ? node.outcome == 'loss'
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.mood_bad_outlined,
                      color: Colors.red,
                      size: 32,
                    ),
                  )
                : node.outcome == 'win'
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.emoji_events_outlined,
                          color: Colors.blue,
                          size: 32,
                        ),
                      )
                    : Icon(
                        Icons.expand_more_outlined,
                        color: Colors.black45,
                      )
            : IconButton(
                onPressed: onDone,
                icon: Icon(Icons.arrow_circle_down_outlined),
                iconSize: 32,
              )
      ],
    );
  }
}
