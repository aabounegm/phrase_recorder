import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:phrase_recorder/models/Phrase.dart';
import 'package:phrase_recorder/screens/PhraseList.dart';

class PhraseRoutePath {
  final String? id;

  const PhraseRoutePath.home() : id = null;
  const PhraseRoutePath.details(this.id);
}

class PhraseRouteInformationParser
    extends RouteInformationParser<PhraseRoutePath> {
  @override
  Future<PhraseRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.location;
    if (location == null) return PhraseRoutePath.home();

    final uri = Uri.parse(location);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return PhraseRoutePath.home();
    }

    // Handle '/phrase/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'phrase') return PhraseRoutePath.home();
      final id = uri.pathSegments[1];
      return PhraseRoutePath.details(id);
    }

    // Handle unknown routes
    return PhraseRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(PhraseRoutePath path) {
    final id = path.id;
    if (id == null) {
      return RouteInformation(location: '/');
    }
    return RouteInformation(location: '/phrase/$id');
  }
}

class PhraseRouterDelegate extends RouterDelegate<PhraseRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PhraseRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  Phrase? _selectedPhrase;

  Iterable<Phrase> phrases = [];

  PhraseRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  PhraseRoutePath get currentConfiguration {
    final phrase = _selectedPhrase;
    return phrase == null
        ? PhraseRoutePath.home()
        : PhraseRoutePath.details(phrase.id);
  }

  @override
  Widget build(BuildContext context) {
    final phrase = _selectedPhrase;

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: Text('An error occurred initializing Firebase')),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final db = FirebaseFirestore.instance;
            return Navigator(
              key: navigatorKey,
              pages: [
                MaterialPage(
                  key: ValueKey('PhrasesListPage'),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: db.collection('phrases').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(body: Text('Loading data...'));
                        }

                        final data = snapshot.data;
                        var dir = Directory('');
                        Future<void> getPhrases() async {
                          var appDir = await getApplicationDocumentsDirectory();
                          dir = Directory('${appDir.path}/recordings');
                          await dir.create(recursive: true);
                          if (data == null) return;
                          var promises = data.docs.map((doc) async {
                            var json = doc.data() as dynamic;
                            var path = '${dir.path}/${doc.id}.aac';
                            var exists = await File(path).exists();
                            return Phrase(
                              doc.id,
                              json == null ? '' : json['text'],
                              exists: exists,
                              path: path,
                            );
                          });
                          phrases = await Future.wait(promises);
                        }

                        return FutureBuilder(
                          future: getPhrases(),
                          builder: (_ctx, _snap) {
                            return PhraseListScreen(
                              [
                                Phrase('1', 'Phrase #1',
                                    path: 'phrase_1', exists: true),
                                Phrase('2', 'Phrase #2',
                                    path: 'phrase_2', exists: true),
                                Phrase('3', 'Phrase #3', path: 'phrase_3')
                              ],
                              directory: dir,
                            );
                          },
                        );
                      }),
                ),
              ],
              onPopPage: (route, result) {
                if (!route.didPop(result)) {
                  return false;
                }

                // Update the list of pages by setting _selectedPhrase to null
                _selectedPhrase = null;
                notifyListeners();

                return true;
              },
            );
          }
          return Scaffold(body: Center(child: Text('Initializing...')));
        });
  }

  @override
  Future<void> setNewRoutePath(PhraseRoutePath path) async {
    final id = path.id;
    if (id != null && phrases.isNotEmpty) {
      _selectedPhrase = phrases.singleWhere((phrase) => phrase.id == id);
    } else {
      _selectedPhrase = null;
    }
  }

  void _handlePhraseTapped(Phrase phrase) {
    _selectedPhrase = phrase;
    notifyListeners();
  }

  void _handleSave() {
    _selectedPhrase = null;
    notifyListeners();
  }
}
