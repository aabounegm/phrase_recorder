import 'package:flutter/material.dart';
import 'package:phrase_recorder/phrases/phrase_list.dart';
import 'package:phrase_recorder/store.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChapterListScreen extends StatefulWidget {
  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SmartRefresher(
              header: MaterialClassicHeader(
                color: Colors.blue,
              ),
              controller: _refreshController,
              onRefresh: () => loadChapters().then((_) {
                setState(() {});
                _refreshController.refreshCompleted();
              }),
              // onLoading: _onLoading,
              child: ListView(
                children: [
                  if (chapters.isEmpty && !_refreshController.isRefresh)
                    Center(child: Text('No chapters yet')),
                  for (final c in chapters)
                    ListTile(
                      title: Text(
                        c.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: c.subtitle == null ? null : Text(c.subtitle!),
                      trailing: Text('${c.recorded} / ${c.phrases.length}'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhraseListScreen(
                            chapter: c,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
