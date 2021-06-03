import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:phrase_recorder/phrases/Phrase.dart';

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
    return _loading
        ? Container(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(),
          )
        : IconButton(
            icon: Icon(Icons.cloud_upload_outlined),
            onPressed: widget.phrases.isEmpty ? null : upload,
            tooltip: 'Upload',
          );
  }
}
