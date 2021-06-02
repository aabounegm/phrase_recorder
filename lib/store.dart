import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phrase_recorder/models/Phrase.dart';

List<Phrase> phrases = [];
Directory recsDir = Directory('recordings');

Future<void> loadPhrases() async {
  var docsDir = await getApplicationDocumentsDirectory();
  recsDir = Directory('${docsDir.path}/recordings');
  await recsDir.create(recursive: true);

  phrases.clear();
  await FirebaseFirestore.instance
      .collection('phrases')
      .withConverter(
        fromFirestore: (snapshot, _) => Phrase.fromJson(
          snapshot.data()!,
          snapshot.id,
        ),
        toFirestore: (Phrase object, _) => object.toJson(),
      )
      .get()
      .then((d) async {
    if (d.docs.isEmpty) return;
    for (final doc in d.docs) {
      final phrase = doc.data();
      phrase.path = '${recsDir.path}/${doc.id}.aac';
      phrase.exists = await File(phrase.path).exists();
      phrases.add(phrase);
    }
  });
}
