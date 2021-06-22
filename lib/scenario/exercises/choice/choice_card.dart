import 'package:flutter/material.dart';
import '../choice_exercise.dart';

class ChoiceCard extends StatelessWidget {
  final ChoiceExercise exercise;
  final List<String> state;
  final Function()? onChanged;

  const ChoiceCard(
    this.exercise, {
    required this.state,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in exercise.options)
          CheckboxListTile(
            title: Text(option.text),
            value: state.contains(option.id),
            onChanged: onChanged == null
                ? null
                : (checked) {
                    if (checked == null) return;
                    if (!exercise.multichoice) {
                      state.clear();
                    }
                    if (checked) {
                      state.add(option.id);
                    } else {
                      state.remove(option.id);
                    }
                    onChanged!();
                  },
          ),
      ],
    );
  }
}
