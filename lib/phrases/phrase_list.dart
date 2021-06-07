import 'package:flutter/material.dart';
import 'package:phrase_recorder/chapters/chapter.dart';
import 'package:phrase_recorder/phrases/phrase.dart';
import 'package:phrase_recorder/store.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'phrase_recorder.dart';
import 'upload_button.dart';

class PhraseListScreen extends StatefulWidget {
  final Chapter chapter;
  PhraseListScreen({required this.chapter});

  @override
  _PhraseListScreenState createState() => _PhraseListScreenState();
}

class _PhraseListScreenState extends State<PhraseListScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );
  List<Phrase> get phrases => widget.chapter.phrases;
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
          UploadButton(chapter: widget.chapter),
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
              onRefresh: () => loadPhrases(widget.chapter).then((_) {
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
                      ? phrases.where((p) => p.exists)
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
                          p.exists ? Icon(Icons.audiotrack_outlined) : null,
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
