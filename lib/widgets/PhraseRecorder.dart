import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:phrase_recorder/models/Phrase.dart';

class PhraseRecorder extends StatefulWidget {
  final Phrase phrase;
  final void Function() onUpdate;
  final void Function()? moveNext;
  final void Function()? movePrev;
  final bool autoReplay;

  PhraseRecorder(
    this.phrase, {
    required this.onUpdate,
    this.moveNext,
    this.movePrev,
    this.autoReplay = false,
  });

  @override
  _PhraseRecorderState createState() => _PhraseRecorderState();
}

class _PhraseRecorderState extends State<PhraseRecorder> {
  var _isRecording = false;
  var _isPlaying = false;
  var _playerIsInited = false;
  var _recorderIsInited = false;
  final _player = FlutterSoundPlayer();
  final _recorder = FlutterSoundRecorder();

  @override
  void initState() {
    // Be careful: openAudioSession returns a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _player.openAudioSession().then((value) {
      setState(() {
        _playerIsInited = true;
      });
    });
    openTheRecorder();
    super.initState();
  }

  @override
  void dispose() {
    stopPlaying(disposing: true);
    _player.closeAudioSession();

    stopRecording(disposing: true);
    _recorder.closeAudioSession();

    super.dispose();
  }

  Future<void> openTheRecorder() async {
    await Permission.microphone.request();
    await _recorder.openAudioSession();
    setState(() {
      _recorderIsInited = true;
    });
  }

  Future<void> startRecording() async {
    await _recorder.startRecorder(toFile: widget.phrase.id);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> stopRecording({bool disposing = false}) async {
    await _recorder.stopRecorder();
    if (disposing) return;
    setState(() {
      _isRecording = false;
    });
    widget.onUpdate();
  }

  Future<void> deleteRecording() async {
    await File(widget.phrase.path).delete();
    widget.onUpdate();
  }

  Future<void> startPlaying() async {
    assert(_playerIsInited);
    setState(() {
      _isPlaying = true;
    });
    await _player.startPlayer(
      fromURI: widget.phrase.path,
      whenFinished: () {
        setState(() {
          _isPlaying = false;
        });
      },
    );
  }

  Future<void> stopPlaying({bool disposing = false}) async {
    await _player.stopPlayer();
    if (disposing) return;
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 0),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: widget.movePrev,
                icon: Icon(Icons.skip_previous_outlined),
                iconSize: 28,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.phrase.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: widget.moveNext,
                icon: Icon(Icons.skip_next_outlined),
                iconSize: 28,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outline),
              iconSize: 32,
              color: Colors.black,
              onPressed: widget.phrase.exists ? deleteRecording : null,
              tooltip: 'Delete recording',
            ),
            GestureDetector(
              onTapDown: (_) => startRecording(),
              onVerticalDragEnd: (_) => stopRecording(),
              onTapUp: (_) => stopRecording(),
              child: IconButton(
                icon: Icon(Icons.mic_none_outlined),
                color: _isRecording ? Colors.blue : Colors.black,
                iconSize: 42,
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.stop_outlined : Icons.play_arrow_outlined,
              ),
              iconSize: 32,
              color: Colors.black,
              onPressed: widget.phrase.exists
                  ? _isPlaying
                      ? stopPlaying
                      : startPlaying
                  : null,
              tooltip: _isPlaying ? 'Stop playback' : 'Replay recording',
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
