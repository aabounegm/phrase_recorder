import 'package:flutter/material.dart';
import 'package:phrase_recorder/chapters/chapter.dart';
import 'package:phrase_recorder/phrases/phrase.dart';
import 'package:phrase_recorder/phrases/sound_manager.dart';
import 'package:phrase_recorder/store.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool autoPlay = false;
  bool autoNext = false;

  @override
  void initState() {
    super.initState();
    phrase = phrases.first;
    SoundManager.init();

    SharedPreferences.getInstance().then(
      (prefs) => setState(() {
        autoPlay = prefs.getBool('autoPlay') ?? false;
        autoNext = prefs.getBool('autoNext') ?? false;
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SoundManager.dispose();
  }

  void changePhrase(int delta) {
    final i = phrase == null ? -1 : phrases.indexOf(phrase!);
    final l = phrases.length;
    final j = ((i + delta) + l) % l;
    SoundManager.stop();
    setState(() {
      phrase = phrases[j];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!SoundManager.initialized) {
      return Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$recorded / ${phrases.length}',
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                autoPlay = !autoPlay;
              });
              SharedPreferences.getInstance().then(
                (prefs) => prefs.setBool('autoPlay', autoPlay),
              );
            },
            icon: Icon(
              Icons.play_circle_outline_outlined,
              color: autoPlay ? Colors.blue : null,
            ),
            tooltip: 'Replay after recording',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                autoNext = !autoNext;
              });
              SharedPreferences.getInstance().then(
                (prefs) => prefs.setBool('autoNext', autoNext),
              );
            },
            icon: Icon(
              Icons.skip_next_outlined,
              color: autoNext ? Colors.blue : null,
            ),
            tooltip: 'Select next after recording',
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
                  phrase = phrases.first;
                });
                _refreshController.refreshCompleted();
              }),
              // onLoading: _onLoading,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(widget.chapter.title),
                    subtitle: widget.chapter.subtitle == null
                        ? null
                        : Text(widget.chapter.subtitle!),
                  ),
                  if (phrases.isEmpty && !_refreshController.isRefresh)
                    Center(child: Text('No phrases yet'))
                  else
                    Divider(height: 0),
                  for (final p in phrases)
                    ListTile(
                      title: Text(p.text),
                      trailing:
                          p.exists ? Icon(Icons.audiotrack_outlined) : null,
                      onTap: () {
                        SoundManager.stop();
                        setState(() {
                          phrase = p;
                        });
                      },
                      selected: phrase == p,
                    )
                ],
              ),
            ),
          ),
          if (phrase != null)
            PhraseRecorder(
              phrase!,
              onUpdate: () async {
                await phrase!.checkIfExists();
                setState(() {});
              },
              movePrev: () => changePhrase(-1),
              moveNext: () => changePhrase(1),
              autoNext: autoNext,
              autoPlay: autoPlay,
            ),
        ],
      ),
    );
  }
}
