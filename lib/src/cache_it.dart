import 'dart:collection';

import 'package:uuid/uuid.dart';

import 'cache_entry.dart';

///
///
///
class CacheIt<K, V> {
  ///
  /// default contructor. Takes an optional [ttl] paramter
  ///
  CacheIt({int ttl}) : _ttl = ttl?.abs() ?? 3600;

  final HashMap<K, CacheEntry<V>> _cache = HashMap<K, CacheEntry<V>>();

  int _ttl;

  ///
  final String id = Uuid().v4();

  ///
  /// Retrieve cache value associated with [key].
  ///
  /// Returns null if the entry does not exist or has expired.
  ///
  V get(K key) => _cache[key]?.data;

  ///
  /// Add new [key] and [value] entry to the cache.
  ///
  ///
  void add(K key, V value) => _cache.putIfAbsent(key, () => CacheEntry<V>(value, ttl: ttl));

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
  /// retrieve ttl for this particular cache.
  ///
  int get ttl => _ttl;

  ///
  /// set the cache default ttl for entries.
  ///
  ///
  set ttl(int value) => _ttl = value?.abs() ?? 3600;

  ///
  /// Returns the number of cache entries
  ///
  int get length => _cache.length;

  ///
  ///
  ///
  // V get entries => _cache.entries.map((entry) => entry.value);

  Iterable<V> get entries {
    final List<V> values = _cache.entries.map((MapEntry<K, CacheEntry<V>> entry) {
      return entry.value.data;
    }).toList();

    return values;
  }
}
