import 'package:flutter/material.dart';

class TypingExercise extends StatelessWidget {
  final String exercise;
  final List<String> state;
  final Function()? onChanged;

  late final List<String> blocks;

  TypingExercise(
    this.exercise, {
    required this.state,
    this.onChanged,
  }) {
    blocks = exercise.split('###');
    if (state.length != blocks.length) {
      state
        ..clear()
        ..addAll(blocks.map((_) => ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 16);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Wrap(
        runSpacing: 8,
        children: [
          for (var i = 0; i < blocks.length - 1; i++) ...[
            Text(
              blocks[i],
              style: style,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 48),
              child: IntrinsicWidth(
                child: TextField(
                  textAlign: TextAlign.center,
                  style: style,
                  decoration: InputDecoration.collapsed(
                    hintText: '***',
                    filled: true,
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: onChanged == null
                      ? null
                      : (text) {
                          state[i] = text;
                          onChanged!();
                        },
                ),
              ),
            )
          ],
          if (blocks.length.isOdd)
            Text(
              blocks.last,
              style: style,
            ),
        ],
      ),
    );
  }
}
