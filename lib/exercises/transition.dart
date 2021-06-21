class Transition {
  final String target;
  final int? score;
  final String? check;
  final String filter;
  final String? value;

  const Transition(
    this.target, {
    this.score,
    this.check,
    this.filter = 'equals',
    this.value,
  });

  Transition.fromJSON(
    Map<String, dynamic> json,
  ) : this(
          json['target'],
          score: json['score'],
          check: json['check'],
          filter: json['filter'],
          value: json['value'],
        );

  bool evaluate(Map<String, Set<String>> state) {
    final set = state[check];
    if (set == null || value == null) return true;

    final values = value!.split(',');
    final contains = values.every((v) => set.contains(v));

    switch (filter) {
      case 'equals':
        return values.length == set.length && contains;
      case 'contains':
        return contains;
      default:
        return false;
    }
  }
}
