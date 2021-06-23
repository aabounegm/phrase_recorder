import 'package:flutter/material.dart';
import 'option.dart';

class ChoiceExercise extends StatelessWidget {
  final List<Option> exercise;
  final List<String> state;
  final Function()? onChanged;

  const ChoiceExercise(
    this.exercise, {
    required this.state,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in exercise)
          RadioListTile(
            title: Text(option.text),
            value: option.id,
            groupValue: state.isEmpty ? null : state.first,
            onChanged: onChanged == null
                ? null
                : (_) {
                    state
                      ..clear()
                      ..add(option.id);
                    onChanged!();
                  },
          ),
      ],
    );
  }
}
