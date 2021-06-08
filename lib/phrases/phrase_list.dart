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
  final RefreshController _refreshController = RefreshController();
  Phrase? phrase;

  List<Phrase> get phrases => widget.chapter.phrases;
  int get recorded => widget.chapter.phrases.where((p) => p.exists).length;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chapter.title),
            if (widget.chapter.subtitle != null)
              Text(
                widget.chapter.subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
        actions: [
          Center(
            child: Text(
              '$recorded / ${phrases.length}',
            ),
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
                  Divider(height: 0),
                  if (phrases.isEmpty && !_refreshController.isRefresh)
                    Center(child: Text('No phrases yet')),
                  for (final p in phrases)
                    ListTile(
                      title: Text(p.text),
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
