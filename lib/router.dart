import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phrase_recorder/models/Phrase.dart';
import 'package:phrase_recorder/screens/PhraseDetails.dart';
import 'package:phrase_recorder/screens/PhraseList.dart';

class PhraseRoutePath {
  final String? id;

  const PhraseRoutePath.home() : id = null;
  const PhraseRoutePath.details(this.id);
}

class PhraseDetailsPage extends Page {
  final Phrase phrase;
  final VoidCallback onSave;

  PhraseDetailsPage({
    required this.phrase,
    required this.onSave,
  }) : super(key: ValueKey(phrase));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return PhraseDetailsScreen(phrase: phrase, onSave: onSave);
      },
    );
  }
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
                        phrases = data == null
                            ? []
                            : data.docs.map((e) =>
                                Phrase.fromMap({...e.data(), 'id': e.id}));

                        return PhraseListScreen(
                          phrases: phrases,
                          onTapped: _handlePhraseTapped,
                        );
                      }),
                ),
                if (phrase != null)
                  PhraseDetailsPage(phrase: phrase, onSave: _handleSave),
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
