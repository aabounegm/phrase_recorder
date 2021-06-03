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
  Future<void> upload() async {
    final files = widget.phrases.map((p) => File(p.path)).toList();
    final zipFile = File('${widget.directory.path}/all.zip');
    await ZipFile.createFromFiles(
      sourceDir: widget.directory,
      files: files,
      zipFile: zipFile,
    );
    await FirebaseStorage.instance
        .ref('uploads/recordings_new.zip')
        .putFile(zipFile);
    await zipFile.delete();
    await Future.wait(files.map((file) => file.delete()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Content uploaded successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.cloud_upload_outlined),
      onPressed: widget.phrases.isEmpty
          ? null
          : () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  upload().then((_) => Navigator.pop(context));
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      contentPadding: const EdgeInsets.all(0),
                      content: Container(
                        height: 128,
                        width: 128,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Uploading, please wait...'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      tooltip: 'Upload',
    );
  }
}
