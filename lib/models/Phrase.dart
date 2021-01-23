class Phrase {
  final String id;
  final String text;

  const Phrase(this.id, this.text);
  factory Phrase.fromMap(Map<String, dynamic> json) => Phrase(
        json['id'],
        json['text'],
      );
}
