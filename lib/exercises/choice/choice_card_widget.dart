import 'package:flutter/material.dart';
import 'choice_exercise.dart';

class ChoiceCard extends StatefulWidget {
  final ChoiceExercise exercise;
  final ValueSetter<Set<String>?>? onChanged;

  const ChoiceCard(
    this.exercise, {
    this.onChanged,
  });

  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  late final selected = <String>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in widget.exercise.options)
          CheckboxListTile(
            title: Text(option.text),
            value: selected.contains(option.id),
            onChanged: widget.onChanged == null
                ? null
                : (checked) {
                    if (checked == null) return;
                    if (!widget.exercise.multichoice) {
                      selected.clear();
                    }
                    if (checked) {
                      selected.add(option.id);
                    } else {
                      selected.remove(option.id);
                    }
                    if (selected.isNotEmpty) widget.onChanged!(selected);
                    setState(() {});
                  },
          ),
      ],
    );
  }
}
