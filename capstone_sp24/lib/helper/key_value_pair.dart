class KeyValuePair<K, V> {
  K key;
  V value;

  KeyValuePair(this.key, this.value);

  @override
  String toString() => 'Key: $key, Value: $value';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyValuePair &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
