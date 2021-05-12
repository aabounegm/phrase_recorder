import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:phrase_recorder/models/Phrase.dart';

class PhraseRecorder extends StatefulWidget {
  final Phrase phrase;
  final Phrase? phrase_previous;

  PhraseRecorder(this.phrase, {this.phrase_previous});

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

  Future<void> startRecording(Phrase? phrase) async {
    if (phrase == null) return;
    await _recorder.startRecorder(toFile: phrase.id);
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

  Future<void> startPlaying(Phrase? phrase) async {
    if (phrase == null) return;
    assert(_playerIsInited);
    setState(() {
      _isPlaying = true;
    });
    await _player.startPlayer(
        fromURI: phrase.path,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        });
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTapDown: widget.phrase_previous != null && _recorderIsInited
                ? (_) => startRecording(widget.phrase_previous)
                : null,
            onVerticalDragEnd:
                _recorderIsInited ? (_) => stopRecording() : null,
            onTapUp: _recorderIsInited ? (_) => stopRecording() : null,
            child: IconButton(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              iconSize: 42,
              onPressed: null,
            ),
          ),
          if (_isPlaying)
            IconButton(
              icon: Icon(Icons.stop),
              iconSize: 42,
              onPressed: widget.phrase_previous == null ? null : stopPlaying,
              tooltip: 'Stop playback',
            )
          else
            IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: 42,
              onPressed: widget.phrase_previous == null
                  ? null
                  : () => startPlaying(widget.phrase_previous),
              tooltip: 'Replay recording',
            ),
          GestureDetector(
            onTapDown:
                _recorderIsInited ? (_) => startRecording(widget.phrase) : null,
            onVerticalDragEnd:
                _recorderIsInited ? (_) => stopRecording() : null,
            onTapUp: _recorderIsInited ? (_) => stopRecording() : null,
            child: IconButton(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              iconSize: 42,
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
