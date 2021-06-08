import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:phrase_recorder/chapters/chapter.dart';
import 'package:phrase_recorder/store.dart';

class UploadButton extends StatelessWidget {
  final Chapter chapter;
  UploadButton({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.cloud_upload_outlined),
      onPressed: chapter.phrases.isEmpty
          ? null
          : () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  upload().then((_) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Content uploaded successfully!'),
                      ),
                    );
                  });
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

  Future<void> upload() async {
    final files =
        chapter.phrases.where((p) => p.exists).map((p) => p.file).toList();
    final zipFile = File('${root.path}/${chapter.id}.zip');
    await ZipFile.createFromFiles(
      sourceDir: root,
      files: files,
      zipFile: zipFile,
    );
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    await FirebaseStorage.instance
        .ref('recordings/${chapter.id}/$timestamp.zip')
        .putFile(zipFile);
    await zipFile.delete();
    // await Future.wait(files.map((file) => file.delete()));
  }
}
