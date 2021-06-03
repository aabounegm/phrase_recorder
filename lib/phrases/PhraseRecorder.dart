import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:phrase_recorder/phrases/Phrase.dart';

class PhraseRecorder extends StatefulWidget {
  final Phrase phrase;
  final void Function() onUpdate;
  final void Function()? moveNext;
  final void Function()? movePrev;

  PhraseRecorder(
    this.phrase, {
    required this.onUpdate,
    this.moveNext,
    this.movePrev,
  });

  @override
  _PhraseRecorderState createState() => _PhraseRecorderState();
}

class _PhraseRecorderState extends State<PhraseRecorder> {
  final player = FlutterSoundPlayer();
  final recorder = FlutterSoundRecorder();
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    Permission.microphone
        .request()
        .then((_) => recorder.openAudioSession())
        .then((_) => player.openAudioSession())
        .then(
          (_) => setState(() {
            initialized = true;
          }),
        );
  }

  @override
  void dispose() {
    player.stopPlayer();
    player.closeAudioSession();
    stopRecording();
    recorder.stopRecorder();
    recorder.closeAudioSession();
    super.dispose();
  }

  void stopRecording() {
    recorder.stopRecorder().then((_) => widget.onUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
          bottom: Radius.zero,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: initialized
          ? Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      onPressed: widget.phrase.recorded
                          ? () => player
                              .stopPlayer()
                              .then((_) => File(widget.phrase.path).delete())
                              .then((_) => widget.onUpdate())
                          : null,
                      tooltip: 'Delete recording',
                    ),
                    GestureDetector(
                      onTapDown: (_) => recorder
                          .startRecorder(toFile: widget.phrase.path)
                          .then((_) => setState(() {})),
                      onTapCancel: () => stopRecording(),
                      onVerticalDragEnd: (_) => stopRecording(),
                      onTapUp: (_) => stopRecording(),
                      child: IconButton(
                        icon: Icon(Icons.mic_none_outlined),
                        color:
                            recorder.isRecording ? Colors.blue : Colors.black,
                        iconSize: 42,
                        onPressed: () {},
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        player.isPlaying
                            ? Icons.stop_outlined
                            : Icons.play_arrow_outlined,
                      ),
                      iconSize: 32,
                      color: Colors.black,
                      onPressed: widget.phrase.recorded
                          ? () {
                              (player.isPlaying
                                      ? player.stopPlayer()
                                      : player.startPlayer(
                                          fromURI: widget.phrase.path,
                                          whenFinished: () => setState(() {}),
                                        ))
                                  .then((_) => setState(() {}));
                            }
                          : null,
                      tooltip: player.isPlaying
                          ? 'Stop playback'
                          : 'Replay recording',
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
