import 'package:flutter/material.dart';
import 'package:phrase_recorder/firebase_builder.dart';
import 'package:phrase_recorder/models/Phrase.dart';
import 'package:phrase_recorder/store.dart';
import 'package:phrase_recorder/widgets/PhraseRecorder.dart';
import 'package:phrase_recorder/widgets/UploadButton.dart';

class PhraseListScreen extends StatefulWidget {
  @override
  _PhraseListScreenState createState() => _PhraseListScreenState();
}

class _PhraseListScreenState extends State<PhraseListScreen> {
  late Phrase? phrase;
  late Future<void>? loader;
  bool autoReplay = true;

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
            IconButton(
              icon: Icon(
                Icons.replay_outlined,
                color: autoReplay ? Colors.blue : Colors.black,
              ),
              onPressed: () => setState(
                () => autoReplay = !autoReplay,
              ),
            ),
            UploadButton(
              phrases: phrases.where((p) => p.exists),
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
                            trailing: p.exists ? Icon(Icons.check) : null,
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
                          onUpdate: () => setState(() async {
                            await phrase!.checkIfExists();
                          }),
                          movePrev: () => changePhrase(-1),
                          moveNext: () => changePhrase(1),
                        )
                ],
              ),
      ),
    );
  }
}
