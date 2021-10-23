import 'dart:core';
import 'dart:math' as math;

///
class CacheEntry<T> {
  /// CacheEntry with optionsl ttl value (default 3600s)
  CacheEntry(T data, {int ttl = 3600})
      : assert(data != null),
        _data = data,
        _expiresAt = DateTime.now().toUtc().add(Duration(seconds: ttl.abs()));

  final T _data;

  final DateTime _expiresAt;

  /// Returns the cached data or null if expired
  T? get data => hasExpired ? null : _data;

  @override
  String toString() => 'Expires in: $expiresIn, value: $data';

  /// Returns the number of seconds before expiration
  int get expiresIn => math.max<int>(0, _expiresAt.difference(DateTime.now().toUtc()).inSeconds);

  /// Returns true if cashed is expired
  bool get hasExpired => expiresIn == 0;
}
