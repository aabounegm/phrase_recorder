import 'package:flutter/material.dart';
import 'package:phrase_recorder/firebase_builder.dart';
import 'package:phrase_recorder/phrases/Phrase.dart';
import 'package:phrase_recorder/store.dart';
import 'PhraseRecorder.dart';
import 'UploadButton.dart';

class PhraseListScreen extends StatefulWidget {
  @override
  _PhraseListScreenState createState() => _PhraseListScreenState();
}

class _PhraseListScreenState extends State<PhraseListScreen> {
  late Phrase? phrase;
  late Future<void>? loader;

  @override
  void initState() {
    super.initState();
    loader = loadPhrases().then(
      (_) => setState(() {
        phrase = phrases[0];
      }),
    );
  }

  void changePhrase(int delta) {
    final i = phrase == null ? -1 : phrases.indexOf(phrase!);
    final l = phrases.length;
    final j = ((i + delta) + l) % l;
    setState(() {
      phrase = phrases[j];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseBuilder(
      future: loader,
      builder: () => Scaffold(
        appBar: AppBar(
          title: Text('Phrase list'),
          actions: [
            UploadButton(
              phrases: phrases.where((p) => p.recorded),
              directory: recsDir,
            ),
            SizedBox(width: 8),
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
                            subtitle: Text(p.id),
                            trailing: p.recorded ? Icon(Icons.check) : null,
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
                          onUpdate: () => phrase!
                              .checkIfExists()
                              .then((_) => setState(() {})),
                          movePrev: () => changePhrase(-1),
                          moveNext: () => changePhrase(1),
                        )
                ],
              ),
      ),
    );
  }
}
