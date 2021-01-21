import 'package:flutter/material.dart';
import 'package:phrase_recorder/models/Phrase.dart';

class PhraseDetailsScreen extends StatelessWidget {
  final Phrase phrase;

  PhraseDetailsScreen({required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phrase'),
      ),
      body: Container(
        child: Text('${phrase.id}) ${phrase.text}'),
      ),
    );
  }
}
