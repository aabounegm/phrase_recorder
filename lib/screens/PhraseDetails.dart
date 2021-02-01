import 'package:flutter/material.dart';
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
  var _finishedRecording = false;

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
                      : Theme.of(context).buttonColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  size: 72,
                ),
              ),
              onTapDown: (_details) {
                setState(() {
                  _isRecording = true;
                  _finishedRecording = false;
                });
              },
              onTapUp: (_details) {
                setState(() {
                  _isRecording = false;
                  _finishedRecording = true;
                });
              },
            ),
            if (_finishedRecording)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _finishedRecording = false;
                      });
                    },
                    tooltip: 'Discard recording',
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {},
                    tooltip: 'Replay recording',
                  ),
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      widget.onSave();
                    },
                    tooltip: 'Save and continue',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
