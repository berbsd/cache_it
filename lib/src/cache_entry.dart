import 'dart:core';
import 'dart:math' as math;

///
///
///
class CacheEntry<T> {
  /// Creates a new cache entry for object of type T. The optional ttl parameter
  /// can be set to change the default expiration of one hour for an entry.
  CacheEntry(T data, {int? ttl})
      : _data = data,
        _expiresAt = DateTime.now().toUtc().add(Duration(seconds: ttl?.abs() ?? 3600));

  final T _data;

  final DateTime _expiresAt;

  /// Returns the data associated with this entry or null if expired.
  T? get data => hasExpired ? null : _data;

  @override
  String toString() => 'ExpiresIn $expiresIn,  hasValue $data';

  /// Returns the number of seconds before the entry expires, zero if expired.
  int get expiresIn => math.max<int>(0, _expiresAt.difference(DateTime.now().toUtc()).inSeconds);

  /// Returns true if the entry has expired, false otherwise.
  bool get hasExpired => expiresIn == 0;
}
