import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:phrase_recorder/models/Phrase.dart';

class PhraseRecorder extends StatefulWidget {
  final Phrase phrase;
  final void Function()? moveNext;
  final bool autoReplay;

  PhraseRecorder(
    this.phrase, {
    this.moveNext,
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
  var _playbackReady = false;
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
    if (widget.phrase.exists) {
      _playbackReady = true;
    }
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
      _playbackReady = false;
    });
  }

  Future<void> stopRecording({bool disposing = false}) async {
    await _recorder.stopRecorder();
    if (disposing) return;
    setState(() {
      _isRecording = false;
      _playbackReady = true;
    });
  }

  Future<void> deleteRecording() async {
    await File(widget.phrase.path).delete();
    setState(() {
      _playbackReady = false;
    });
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
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.phrase.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
              iconSize: 42,
              color: Colors.black,
              onPressed: _isPlaying ? stopPlaying : startPlaying,
              tooltip: _isPlaying ? 'Stop playback' : 'Replay recording',
            ),
            if (_recorderIsInited)
              GestureDetector(
                onTapDown: (_) => startRecording(),
                onVerticalDragEnd: (_) => stopRecording(),
                onTapUp: (_) => stopRecording(),
                child: IconButton(
                  icon: Icon(Icons.mic),
                  color: _isRecording ? Colors.blue : Colors.black,
                  iconSize: 42,
                  onPressed: () {},
                ),
              ),
            if (widget.moveNext != null)
              IconButton(
                icon: Icon(Icons.navigate_next),
                color: Colors.black,
                iconSize: 42,
                onPressed: widget.moveNext,
                tooltip: 'Next phrase',
              ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
