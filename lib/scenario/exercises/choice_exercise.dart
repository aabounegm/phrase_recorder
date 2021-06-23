import 'package:flutter/material.dart';
import 'option.dart';

class ChoiceExercise extends StatelessWidget {
  final List<Option> options;
  final List<String> state;
  final Function()? onChanged;

  const ChoiceExercise(
    this.options, {
    required this.state,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in options)
          RadioListTile(
            title: Text(option.text),
            value: option.id,
            groupValue: state.first,
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
