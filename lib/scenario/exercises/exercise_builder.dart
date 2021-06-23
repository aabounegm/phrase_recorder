import 'package:flutter/material.dart';
import 'package:phrase_recorder/scenario/exercises/typing_exercise.dart';

import 'choice_exercise.dart';
import 'multichoice_exercise.dart';
import 'order_exercise.dart';

Widget buildExercise({
  required String? type,
  required dynamic exercise,
  required List<String> state,
  required Function()? onChanged,
}) {
  if (type == 'choice') {
    return ChoiceExercise(
      exercise,
      state: state,
      onChanged: onChanged,
    );
  }
  if (type == 'multichoice') {
    return MultichoiceExercise(
      exercise,
      state: state,
      onChanged: onChanged,
    );
  }
  if (type == 'typing') {
    return TypingExercise(
      exercise,
      state: state,
      onChanged: onChanged,
    );
  }
  if (type == 'order') {
    return OrderExercise(
      exercise,
      state: state,
      onChanged: onChanged,
    );
  }
  return Offstage();
}
