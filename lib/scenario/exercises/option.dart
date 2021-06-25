class Option {
  final String id;
  final String text;

  Option(this.id, this.text);

  Option.fromJson(
    Map<String, dynamic> json,
  ) : this(
          json['id'],
          json['text'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}
