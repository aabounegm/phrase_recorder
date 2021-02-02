import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phrase_recorder/models/Phrase.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhraseListScreen extends StatelessWidget {
  final Iterable<Phrase> phrases;
  final ValueChanged<Phrase> goToPhrase;
  final Directory directory;

  PhraseListScreen({
    required this.phrases,
    required this.goToPhrase,
    required this.directory,
  });

  @override
  Widget build(BuildContext context) {
    var allDone = phrases.every((p) => p.exists);
    return Scaffold(
      appBar: AppBar(
        title: Text('Phrase list'),
      ),
      body: ListView(
        children: [
          for (final phrase in phrases)
            ListTile(
              title: Text(phrase.text),
              subtitle: Text(phrase.id.toString()),
              trailing:
                  phrase.exists ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () => goToPhrase(phrase),
            )
        ],
      ),
      floatingActionButton:
          allDone ? UploadButton(phrases: phrases, directory: directory) : null,
    );
  }
}

class UploadButton extends StatefulWidget {
  final Iterable<Phrase> phrases;
  final Directory directory;
  UploadButton({
    required this.phrases,
    required this.directory,
  });

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  var _loading = false;
  final storage = FirebaseStorage.instance;

  Future<void> upload() async {
    setState(() {
      _loading = true;
    });
    final files = widget.phrases.map((p) => File(p.path)).toList();
    final zipFile = File('${widget.directory.path}/all.zip');
    await ZipFile.createFromFiles(
        sourceDir: widget.directory, files: files, zipFile: zipFile);
    await storage.ref('uploads/recordings.zip').putFile(zipFile);
    await zipFile.delete();
    await Future.wait(files.map((file) => file.delete()));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Content uploaded successfully!')));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: _loading
          ? CircularProgressIndicator(backgroundColor: Colors.white)
          : Icon(Icons.cloud_upload),
      onPressed: _loading ? null : upload,
      tooltip: 'Upload',
    );
  }
}
