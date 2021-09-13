enum ContentStatus { public, unlisted, private }

class ContentMetaData {
  String id;
  String authorId;
  DateTime lastUpdated;
  int likes;
  ContentStatus status;

  ContentMetaData({
    required this.id,
    required this.authorId,
    required this.lastUpdated,
    this.likes = 0,
    this.status = ContentStatus.private,
  });
}
