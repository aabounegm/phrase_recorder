import 'package:flutter/material.dart';
import 'package:phrase_recorder/models/Phrase.dart';
import 'package:phrase_recorder/screens/PhraseDetails.dart';
import 'package:phrase_recorder/screens/PhraseList.dart';

class PhraseRoutePath {
  final int? id;

  const PhraseRoutePath.home() : id = null;
  const PhraseRoutePath.details(this.id);
}

class PhraseDetailsPage extends Page {
  final Phrase phrase;

  PhraseDetailsPage({
    required this.phrase,
  }) : super(key: ValueKey(phrase));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return PhraseDetailsScreen(phrase: phrase);
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
    if (uri.pathSegments.length == 0) {
      return PhraseRoutePath.home();
    }

    // Handle '/phrase/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'phrase') return PhraseRoutePath.home();
      final remaining = uri.pathSegments[1];
      final id = int.tryParse(remaining);
      if (id == null) return PhraseRoutePath.home();
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
  final GlobalKey<NavigatorState> navigatorKey;

  Phrase? _selectedPhrase;

  List<Phrase> phrases = [
    Phrase(1, 'Robert A. Heinlein'),
    Phrase(2, 'Isaac Asimov'),
    Phrase(3, 'Ray Bradbury'),
  ];

  PhraseRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  PhraseRoutePath get currentConfiguration {
    final phrase = _selectedPhrase;
    return phrase == null
        ? PhraseRoutePath.home()
        : PhraseRoutePath.details(phrase.id);
  }

  @override
  Widget build(BuildContext context) {
    final phrase = _selectedPhrase;

    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('PhrasesListPage'),
          child: PhraseListScreen(
            phrases: phrases,
            onTapped: _handlePhraseTapped,
          ),
        ),
        if (phrase != null) PhraseDetailsPage(phrase: phrase)
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

  @override
  Future<void> setNewRoutePath(PhraseRoutePath path) async {
    final id = path.id;
    if (id != null) {
      _selectedPhrase = phrases[id];
    } else {
      _selectedPhrase = null;
    }
  }

  void _handlePhraseTapped(Phrase phrase) {
    _selectedPhrase = phrase;
    notifyListeners();
  }
}
