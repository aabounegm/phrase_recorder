import 'package:flutter/material.dart';
import 'package:phrase_recorder/phrases/Phrase.dart';
import 'package:phrase_recorder/store.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'PhraseRecorder.dart';
import 'UploadButton.dart';

class PhraseListScreen extends StatefulWidget {
  @override
  _PhraseListScreenState createState() => _PhraseListScreenState();
}

class _PhraseListScreenState extends State<PhraseListScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );
  Phrase? phrase;
  bool recordedOnly = false;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Phrase list'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                recordedOnly = !recordedOnly;
              });
            },
            icon: Icon(Icons.library_music_outlined),
            color: recordedOnly ? Colors.blue : Colors.black,
          ),
          UploadButton(
            phrases: phrases.where((p) => p.recorded),
            directory: recsDir,
          ),
          SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SmartRefresher(
              header: MaterialClassicHeader(
                color: Colors.blue,
              ),
              controller: _refreshController,
              onRefresh: () => loadPhrases().then((_) {
                setState(() {
                  phrase = phrases[0];
                });
                _refreshController.refreshCompleted();
              }),
              // onLoading: _onLoading,
              child: ListView(
                children: [
                  if (phrases.isEmpty && !_refreshController.isRefresh)
                    Center(child: Text('No phrases yet')),
                  for (final p in recordedOnly
                      ? phrases.where((p) => p.recorded)
                      : phrases)
                    ListTile(
                      title: Text(
                        p.text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(p.id),
                      trailing:
                          p.recorded ? Icon(Icons.audiotrack_outlined) : null,
                      onTap: () => setState(() => phrase = p),
                      selected: phrase == p,
                    )
                ],
              ),
            ),
          ),
          if (phrase != null)
            PhraseRecorder(
              phrase as Phrase,
              onUpdate: () => phrase!.checkIfExists().then(
                    (_) => setState(() {}),
                  ),
              movePrev: () => changePhrase(-1),
              moveNext: () => changePhrase(1),
            ),
        ],
      ),
    );
  }
}
