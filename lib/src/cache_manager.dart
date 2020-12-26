import 'dart:async';

import 'package:cache_it/cache_it.dart';

import 'cache_it.dart';

/// Simple cache manager
class CacheManager {
  /// Retrieve singleton instance of cache manager
  factory CacheManager() => _instance;

  CacheManager._() {
    _ticker = Timer.periodic(const Duration(minutes: 15), _handleTicker);
  }

  static final CacheManager _instance = CacheManager._();

  final Map<String, dynamic> _cacheMap = <String, dynamic>{};
  Timer? _ticker;

  void _handleTicker(Timer t) => prune();

  /// Add a new cache to manage
  void add(dynamic cache) {
    if (cache is CacheIt) {
      if (_cacheMap.containsKey(cache.id)) {
        // should not happen
        throw const DuplicateEntryException();
      } else {
        _cacheMap[cache.id] = cache;
      }
    } else {
      throw const TypeException();
    }
  }

  /// Eliminate all expired  values across caches
  void prune() {
    for (final dynamic element in _cacheMap.values) {
      if (element is CacheIt) {
        element.prune();
      }
    }
  }

  /// Clear all caches managed by the configuration manager
  void clear() {
    for (final dynamic element in _cacheMap.values) {
      if (element is CacheIt) {
        element.clear();
      }
    }
  }

  /// Cancel the periodic timer and dispose of resources.
  void dispose() {
    _ticker?.cancel();
    clear();
    _cacheMap.clear();
  }
}
