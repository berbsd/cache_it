import 'dart:collection';

import 'cache_entry.dart';

/// Create an instance of a cache object.
///
class CacheIt<K, V> {
  /// Creates a new CacheIt object. The constructor takes an optional
  /// [ttl] paramter to set time-to-live for entries in seconds. The default
  /// is 3600 seconds or one hour.
  ///
  CacheIt({int? ttl}) : _ttl = ttl?.abs() ?? 3600;

  final HashMap<K, CacheEntry<V>> _cache = HashMap<K, CacheEntry<V>>();

  int _ttl;

  /// Internal cache unique id used for [CacheManager]
  final String id = DateTime.now().toUtc().microsecondsSinceEpoch.toString();

  /// Retrieve cache value associated with [key].
  ///
  /// Returns null if the entry does not exist or has expired.
  ///
  V? get(K key) => _cache[key]?.data;

  ///
  /// Add new [key] and [value] entry to the cache.
  ///
  ///
  void add(K key, V value) => _cache.update(key, (CacheEntry<V> oldValue) => CacheEntry<V>(value, ttl: ttl),
      ifAbsent: () => CacheEntry<V>(value, ttl: ttl));

  ///
  /// Removes all entries from the cache.
  ///
  /// After this, the cache is empty.
  ///
  void clear() => _cache.clear();

  ///
  /// Removes all expired entries from the cache.
  ///
  /// To be used when cache size and space is an issue.
  ///
  void prune() => _cache.removeWhere((K key, CacheEntry<V> value) => value.hasExpired);

  ///
  /// Retrieve [ttl] for this particular cache.
  ///
  int get ttl => _ttl;

  ///
  /// Set the default ttl for the cache object. Changing the value only
  /// impacts new entries.
  ///
  set ttl(int value) => _ttl = value.abs();

  /// Returns the number cached entries, whether expired or not.
  ///
  int get length => _cache.length;

  /// Returns iterable for all entries.
  Iterable<V> get entries {
    final List<V> values = List<V>.empty(growable: true);

    for (final MapEntry<K, CacheEntry<V>> value in _cache.entries) {
      if (!value.value.hasExpired) {
        values.add(value.value.data!);
      }
    }

    return values;
  }

  @override
  String toString() => _cache.entries
      .map((MapEntry<K, CacheEntry<V>> value) => 'key: ${value.key}, value: ${value.value}')
      .toList()
      .join('\n');
}
