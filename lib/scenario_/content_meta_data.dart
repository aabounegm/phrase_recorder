enum ContentStatus { public, unlisted, private }

class ContentMetaData {
  String authorId;
  DateTime lastUpdated;
  ContentStatus status;

  ContentMetaData({
    required this.authorId,
    required this.lastUpdated,
    required this.status,
  });
}
