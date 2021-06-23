import 'package:flutter/material.dart';
import 'option.dart';

class MultichoiceExercise extends StatelessWidget {
  final List<Option> options;
  final List<String> state;
  final Function()? onChanged;

  const MultichoiceExercise(
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
          CheckboxListTile(
            title: Text(option.text),
            value: state.contains(option.id),
            onChanged: onChanged == null
                ? null
                : (checked) {
                    if (checked == null) return;
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
