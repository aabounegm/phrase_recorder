import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:phrase_recorder/phrases/phrase.dart';
import 'package:vibration/vibration.dart';

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
    player
      ..stopPlayer()
      ..closeAudioSession();
    recorder
      ..stopRecorder()
      ..closeAudioSession();
    super.dispose();
  }

  void toggleRecording(bool? recording) {
    recording ??= !recorder.isRecording;
    if (recording) {
      recorder.startRecorder(toFile: widget.phrase.file.path).then((_) {
        Vibration.vibrate(duration: 100);
        setState(() {});
      });
    } else {
      recorder.stopRecorder().then((_) {
        widget.onUpdate();
        Vibration.vibrate(duration: 100);
        togglePlayback(true);
      });
    }
  }

  Future<void> togglePlayback(bool? playing) async {
    playing ??= !player.isPlaying;
    if (playing) {
      await player.startPlayer(
        fromURI: widget.phrase.file.path,
        whenFinished: () => setState(() {}),
      );
    } else {
      await player.stopPlayer();
    }
    setState(() {});
  }

  Future<void> deleteRecord() async {
    var delete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${widget.phrase.text} ?'),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(
                context,
                true,
              ),
              icon: Icon(Icons.delete_forever_outlined, color: Colors.red),
              label: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(
                context,
                false,
              ),
              icon: Icon(Icons.check_outlined),
              label: Text('Keep'),
            ),
          ],
        );
      },
    );
    if (delete == true) {
      await togglePlayback(false);
      await widget.phrase.file.delete();
      widget.onUpdate();
    }
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
                          style: TextStyle(fontSize: 18),
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
                      onPressed: widget.phrase.exists ? deleteRecord : null,
                      tooltip: 'Delete recording',
                    ),
                    GestureDetector(
                      onTapDown: (_) => toggleRecording(true),
                      onTapCancel: () => toggleRecording(false),
                      onVerticalDragEnd: (_) => toggleRecording(false),
                      onTapUp: (_) => toggleRecording(false),
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
                      onPressed: widget.phrase.exists
                          ? () => togglePlayback(null)
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