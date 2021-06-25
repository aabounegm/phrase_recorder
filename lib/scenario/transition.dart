class Transition {
  final String target;
  final int score;
  final String? check;
  final String filter;
  final String? value;

  const Transition(
    this.target, {
    this.score = 0,
    this.check,
    this.filter = 'equals',
    this.value,
  });

  bool evaluate(Map<String, List<String>> state) {
    final set = state[check];
    if (set == null || value == null) return true;

    final values = value!.split(',');

    switch (filter) {
      case 'equals':
        return _equals(set, values);
      case 'contains':
        return _contains(set, values);
      default:
        return false;
    }
  }

  bool _equals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _contains(List<String> a, List<String> b) {
    return b.every((e) => a.contains(e));
  }

  Transition.fromJSON(
    Map<String, dynamic> json,
  ) : this(
          json['target'],
          score: json['score'],
          check: json['check'],
          filter: json['filter'],
          value: json['value'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['target'] = target;
    data['score'] = score;
    if (check != null) {
      data['check'] = check;
    }
    if (filter != 'equals') {
      data['filter'] = filter;
    }
    if (value != null) {
      data['value'] = value;
    }
    return data;
  }
}
