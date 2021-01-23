import 'package:flutter/material.dart';
import 'package:phrase_recorder/models/Phrase.dart';

class PhraseListScreen extends StatelessWidget {
  final Iterable<Phrase> phrases;
  final ValueChanged<Phrase> onTapped;

  PhraseListScreen({required this.phrases, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phrase list'),
      ),
      body: ListView(
        children: [
          for (final phrase in phrases)
            ListTile(
              title: Text(phrase.text),
              subtitle: Text(phrase.id.toString()),
              onTap: () => onTapped(phrase),
            )
        ],
      ),
    );
  }
}
