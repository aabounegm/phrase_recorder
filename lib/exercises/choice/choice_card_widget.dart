import 'package:flutter/material.dart';
import 'package:phrase_recorder/exercises/choice/choice_exericise.dart';
import 'choice_node.dart';

class ChoiceCardWidget extends StatefulWidget {
  final ChoiceNode node;
  final ValueSetter<Set<String>>? onDone;

  const ChoiceCardWidget(
    this.node, {
    this.onDone,
  });

  @override
  _ChoiceCardWidgetState createState() => _ChoiceCardWidgetState();
}

class _ChoiceCardWidgetState extends State<ChoiceCardWidget> {
  late final selected = <String>{};
  bool done = false;

  ChoiceExercise get exercise => widget.node.exercise;

  @override
  void initState() {
    super.initState();
    selected.clear();
  }

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
              for (final option in exercise.options)
                CheckboxListTile(
                  title: Text(option.text),
                  value: selected.contains(option.id),
                  onChanged: done
                      ? null
                      : (checked) {
                          if (checked == null) return;
                          if (!exercise.multichoice) selected.clear();
                          if (checked) {
                            selected.add(option.id);
                          } else {
                            selected.remove(option.id);
                          }
                          setState(() {});
                        },
                ),
            ],
          ),
        ),
        widget.onDone == null || done
            ? Icon(
                Icons.expand_more_outlined,
                color: Colors.black45,
              )
            : IconButton(
                onPressed: selected.isEmpty
                    ? null
                    : () {
                        widget.onDone!(selected);
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
