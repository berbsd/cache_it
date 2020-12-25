import 'package:cache_it/cache_it.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should properly handle expiration after ttl', () async {
    final CacheEntry<int> entry = CacheEntry<int>(5, ttl: 5);
    expect(entry.hasExpired, isFalse);
    await Future<void>.delayed(const Duration(seconds: 6));
    expect(entry.hasExpired, isTrue);
    expect(entry.expiresIn, 0);
  });

  test('should return valid cache', () {
    final CacheEntry<int> entry = CacheEntry<int>(5);
    expect(entry.hasExpired, isFalse);
    expect(entry.data == 5, isTrue);
    expect(entry.hasExpired, isFalse);
    expect(entry.expiresIn >= 3599, isTrue);
  });
}
