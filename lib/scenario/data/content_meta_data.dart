enum ContentStatus { public, unlisted, private }

class ContentMetaData {
  String id;
  String authorId;
  DateTime lastUpdated;
  ContentStatus status;

  ContentMetaData({
    required this.id,
    required this.authorId,
    required this.lastUpdated,
    required this.status,
  });
}
