import 'dart:core';
import 'dart:math' as math;

///
///
///
class CacheEntry<T> {
  ///
  ///
  ///
  CacheEntry(T data, {int ttl})
      : assert(data != null),
        _data = data,
        _expiresAt = DateTime.now().toUtc().add(Duration(seconds: ttl?.abs() ?? 3600));

  final T _data;

  final DateTime _expiresAt;

  ///
  ///
  ///
  T get data => hasExpired ? null : _data;

  @override
  String toString() => 'ExpiresIn $expiresIn,  hasValue ${data != null}';

  ///
  ///
  ///
  int get expiresIn => math.max<int>(0, _expiresAt.difference(DateTime.now().toUtc()).inSeconds);

  ///
  ///
  ///
  bool get hasExpired => expiresIn == 0;
}
