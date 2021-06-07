List<T>? listFromJson<T>(
  Object? array,
  T Function(dynamic) fromJson,
) {
  return (array as Iterable<dynamic>?)?.map((i) => fromJson(i)).toList();
}
