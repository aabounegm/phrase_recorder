import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data/scenario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScenariosScreen extends StatefulWidget {
  const ScenariosScreen();

  @override
  _ScenariosScreenState createState() => _ScenariosScreenState();
}

class _ScenariosScreenState extends State<ScenariosScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );
  List<Scenario> _scenarios = [];

  Future<void> _refreshScenarios() async {
    _scenarios = await FirebaseFirestore.instance
        .collection('scenarios')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              Scenario.fromJson(snapshot.data()!, id: snapshot.id),
          toFirestore: (Scenario object, _) => object.toJson(),
        )
        .get();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scenarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SmartRefresher(
              header: MaterialClassicHeader(
                color: Colors.blue,
              ),
              controller: _refreshController,
              onRefresh: _refreshScenarios,
              // onLoading: _onLoading,
              // child: ListView(
              //   children: [
              //     if (chapters.isEmpty && !_refreshController.isRefresh)
              //       Center(child: Text('No chapters yet')),
              //     for (final c in chapters)
              //       ListTile(
              //         title: Text(
              //           c.title,
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         subtitle: c.subtitle == null ? null : Text(c.subtitle!),
              //         trailing: Text('${c.recorded} / ${c.phrases.length}'),
              //         // onTap: () => Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (context) => PhraseListScreen(
              //         //       chapter: c,
              //         //     ),
              //         //   ),
              //         // ),
              //       )
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
