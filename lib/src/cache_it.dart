import 'dart:collection';

import 'package:uuid/uuid.dart';

import 'cache_entry.dart';

///
/// Create an instance of a cache object.
///
class CacheIt<K, V> {
  ///
  /// Creates a new CacheIt object. The constructor takes an optional
  /// [ttl] paramter to set time-to-live for entries in seconds. The default
  /// is 3600 seconds or one hour.
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
    final List<V> values = _cache.entries.map((MapEntry<K, CacheEntry<V>> entry) {
      return entry.value.data;
    }).toList();

    return values;
  }
}
