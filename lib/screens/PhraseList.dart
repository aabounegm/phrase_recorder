import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phrase_recorder/models/Phrase.dart';
import 'package:phrase_recorder/widgets/PhraseRecorder.dart';
import 'package:phrase_recorder/widgets/UploadButton.dart';

class PhraseListScreen extends StatefulWidget {
  final List<Phrase> phrases;
  final Directory directory;

  const PhraseListScreen(
    this.phrases, {
    required this.directory,
  });

  @override
  _PhraseListScreenState createState() => _PhraseListScreenState();
}

class _PhraseListScreenState extends State<PhraseListScreen> {
  Phrase? phrase;
  bool autoReplay = false;

  @override
  void initState() {
    super.initState();
    if (widget.phrases.isNotEmpty) {
      setState(() => phrase = widget.phrases[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phrases = widget.phrases;
    return Scaffold(
      appBar: AppBar(
        title: Text('Phrase list'),
        actions: [
          IconButton(
            icon: Icon(
              autoReplay ? Icons.replay : Icons.play_disabled,
            ),
            color: Colors.white,
            onPressed: () => setState(() => autoReplay = !autoReplay),
          ),
          UploadButton(
            phrases: phrases.where((p) => p.exists),
            directory: widget.directory,
          )
        ],
      ),
      body: phrases.isEmpty
          ? Center(child: Text('No phrases yet'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      for (final p in phrases)
                        ListTile(
                          title: Text(p.text),
                          subtitle: Text(p.id.toString()),
                          trailing: p.exists
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () => setState(() => phrase = p),
                          selected: phrase == p,
                        )
                    ],
                  ),
                ),
                phrase == null
                    ? Text('Select phrase above')
                    : PhraseRecorder(
                        phrase as Phrase,
                        moveNext: phrase == null
                            ? null
                            : () => setState(
                                  () {
                                    final i = phrases.indexOf(phrase!);
                                    phrase = phrases[(i + 1) % phrases.length];
                                  },
                                ),
                      )
              ],
            ),
    );
  }
}
