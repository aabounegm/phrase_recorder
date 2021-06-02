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
  late Phrase? phrase;
  bool autoReplay = true;

  @override
  void initState() {
    super.initState();
    phrase = widget.phrases[0];
  }

  @override
  Widget build(BuildContext context) {
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
            phrases: widget.phrases.where((p) => p.exists),
            directory: widget.directory,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: widget.phrases.isEmpty
          ? Center(child: Text('No phrases yet'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      for (final p in widget.phrases)
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
                        autoReplay: autoReplay,
                        moveNext: phrase == null
                            ? null
                            : () => setState(
                                  () {
                                    final i = widget.phrases.indexOf(phrase!);
                                    final l = widget.phrases.length;
                                    phrase = widget.phrases[(i + 1) % l];
                                  },
                                ),
                      )
              ],
            ),
    );
  }
}
