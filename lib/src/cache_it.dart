import 'dart:collection';

import 'package:uuid/uuid.dart';

import 'cache_entry.dart';

typedef CacheBuilderFn<V> = Future<V> Function();

///
/// Create an instance of a cache object.
///
class CacheIt<K, V> {
  ///
  /// Creates a new CacheIt object. The constructor takes an optional
  /// [ttl] paramter to set time-to-live for entries in seconds. The default
  /// is 3600 seconds or one hour.
  ///
  CacheIt({int ttl}) : _ttl = ttl?.abs() ?? 600;

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
  /// Retrieve cache value associated with [key].
  ///
  /// In case the value is expired, cache new value from builder and return it.
  ///
  Future<V> getOrUpdate(K key, CacheBuilderFn<V> builder) async {
    return get(key) ?? add(key, await builder());
  }

  ///
  /// Add new [key] and [value] entry to the cache.
  ///
  ///
  V add(K key, V value) => _cache
      .update(key, (CacheEntry<V> oldValue) => CacheEntry<V>(value, ttl: ttl),
          ifAbsent: () => CacheEntry<V>(value, ttl: ttl))
      .data;

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
  set ttl(int value) => _ttl = value?.abs() ?? 3600;

  ///
  /// Returns the number cached entries, whether expired or not.
  ///
  int get length => _cache.length;

  ///
  ///
  ///
  // V get entries => _cache.entries.map((entry) => entry.value);

  Iterable<V> get entries {
    final List<V> values = List<V>.empty(growable: true);

    for (final MapEntry<K, CacheEntry<V>> value in _cache.entries) {
      if (!value.value.hasExpired) {
        values.add(value.value.data);
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
