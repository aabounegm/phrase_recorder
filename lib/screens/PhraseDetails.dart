import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:phrase_recorder/models/Phrase.dart';

class PhraseDetailsScreen extends StatefulWidget {
  final Phrase phrase;
  final VoidCallback onSave;

  PhraseDetailsScreen({required this.phrase, required this.onSave});

  @override
  _PhraseDetailsScreenState createState() => _PhraseDetailsScreenState();
}

class _PhraseDetailsScreenState extends State<PhraseDetailsScreen> {
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
    await _recorder.startRecorder(toFile: widget.phrase.path);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Phrase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.phrase.text,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: _isRecording
                      ? Colors.red[400]
                      : _recorderIsInited
                          ? Theme.of(context).buttonColor
                          : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  size: 72,
                ),
              ),
              onTapDown: _recorderIsInited ? (_) => startRecording() : null,
              onVerticalDragEnd:
                  _recorderIsInited ? (_) => stopRecording() : null,
              onTapUp: _recorderIsInited ? (_) => stopRecording() : null,
            ),
            if (_playbackReady)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    iconSize: 40,
                    onPressed: deleteRecording,
                    tooltip: 'Discard recording',
                  ),
                  if (_isPlaying)
                    IconButton(
                      icon: Icon(Icons.stop),
                      iconSize: 40,
                      onPressed: stopPlaying,
                      tooltip: 'Stop playback',
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      iconSize: 40,
                      onPressed: startPlaying,
                      tooltip: 'Replay recording',
                    ),
                  IconButton(
                    icon: Icon(Icons.save),
                    iconSize: 40,
                    onPressed: widget.onSave,
                    tooltip: 'Save and continue',
                  ),
                ],
              )
            else
              Container(height: 56)
          ],
        ),
      ),
    );
  }
}
