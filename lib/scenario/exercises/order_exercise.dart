import 'dart:math';
import 'package:flutter/material.dart';
import 'option.dart';

class OrderExercise extends StatefulWidget {
  final List<Option> exercise;
  final List<String> state;
  final Function()? onChanged;

  const OrderExercise(
    this.exercise, {
    required this.state,
    this.onChanged,
  });

  @override
  _OrderExerciseState createState() => _OrderExerciseState();
}

class _OrderExerciseState extends State<OrderExercise> {
  late final List<Option> options;

  List<T> shuffleList<T>(List<T> items) {
    var random = Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  @override
  void initState() {
    super.initState();
    options = shuffleList([...widget.exercise]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 192),
      child: ReorderableListView(
        buildDefaultDragHandles: widget.onChanged != null,
        onReorder: (int oldIndex, int newIndex) {
          if (widget.onChanged == null) return;
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = options.removeAt(oldIndex);
            options.insert(newIndex, item);
          });
          widget.state
            ..clear()
            ..addAll(options.map((e) => e.id));
          widget.onChanged!();
        },
        children: [
          for (final o in options)
            ListTile(
              key: Key(o.id),
              title: Text(o.text),
              trailing: widget.onChanged == null
                  ? null
                  : Icon(Icons.drag_handle_outlined),
            ),
        ],
      ),
    );
  }
}
