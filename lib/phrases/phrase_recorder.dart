import 'package:flutter/material.dart';
import 'package:phrase_recorder/phrases/phrase.dart';
import 'package:phrase_recorder/phrases/sound_manager.dart';

class PhraseRecorder extends StatefulWidget {
  final Phrase phrase;
  final void Function() onUpdate;
  final void Function()? moveNext;
  final void Function()? movePrev;
  final bool autoNext;
  final bool autoPlay;

  PhraseRecorder(
    this.phrase, {
    required this.onUpdate,
    this.moveNext,
    this.movePrev,
    this.autoNext = false,
    this.autoPlay = false,
  });

  @override
  _PhraseRecorderState createState() => _PhraseRecorderState();
}

class _PhraseRecorderState extends State<PhraseRecorder> {
  String get file => widget.phrase.file.path;

  Future<void> setRecording(bool? recording) async {
    recording = await SoundManager.setRecording(recording, file: file);
    if (recording) {
      setState(() {});
    } else {
      widget.onUpdate();
      if (widget.autoPlay) {
        await setPlaying(true, autoNext: widget.autoNext);
      } else if (widget.autoNext) {
        widget.moveNext?.call();
      }
    }
  }

  Future<void> setPlaying(
    bool? playing, {
    bool autoNext = false,
  }) async {
    await SoundManager.setPlaying(
      playing,
      file: file,
      whenFinished: () {
        setState(() {});
        if (autoNext && widget.moveNext != null) {
          widget.moveNext!();
          Future.delayed(
            Duration(milliseconds: 50),
            () => setPlaying(true, autoNext: widget.autoNext),
          );
        }
      },
    );
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
      await setPlaying(false);
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
          top: Radius.circular(16),
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
      child: Column(
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
                onTapDown: (_) => setRecording(true),
                onTapCancel: () => setRecording(false),
                onVerticalDragEnd: (_) => setRecording(false),
                onTapUp: (_) => setRecording(false),
                child: IconButton(
                  icon: Icon(Icons.mic_none_outlined),
                  color: SoundManager.recorder.isRecording
                      ? Colors.blue
                      : Colors.black,
                  iconSize: 42,
                  onPressed: () {},
                ),
              ),
              IconButton(
                icon: Icon(
                  SoundManager.player.isPlaying
                      ? Icons.stop_outlined
                      : Icons.play_arrow_outlined,
                ),
                iconSize: 32,
                color: Colors.black,
                onPressed: widget.phrase.exists
                    ? () => setPlaying(null, autoNext: widget.autoNext)
                    : null,
                tooltip: SoundManager.player.isPlaying
                    ? 'Stop playback'
                    : 'Replay recording',
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
