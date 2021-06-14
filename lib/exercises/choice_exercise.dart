import 'package:flutter/material.dart';

class ChoiceExerciseData {
  final String text;
  final String? question;
  final Map<String, String>? options;
  final bool multichoice;

  const ChoiceExerciseData(
    this.text, {
    this.question,
    this.options,
    this.multichoice = false,
  });
}

class ChoiceExercise extends StatefulWidget {
  final ChoiceExerciseData data;
  final ValueSetter<Set<String>>? onDone;

  const ChoiceExercise(
    this.data, {
    required this.onDone,
  });

  @override
  _ChoiceExerciseState createState() => _ChoiceExerciseState();
}

class _ChoiceExerciseState extends State<ChoiceExercise> {
  late final selected = <String>{};
  bool done = false;

  ChoiceExerciseData get data => widget.data;

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
                title: Text(data.text),
                subtitle: data.question == null ? null : Text(data.question!),
              ),
              if (data.options != null)
                for (final entry in data.options!.entries)
                  CheckboxListTile(
                    title: Text(entry.value),
                    value: selected.contains(entry.key),
                    onChanged: done
                        ? null
                        : (checked) {
                            if (checked == null) return;
                            if (!data.multichoice) selected.clear();
                            if (checked) {
                              selected.add(entry.key);
                            } else {
                              selected.remove(entry.key);
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
