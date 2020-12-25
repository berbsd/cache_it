import 'package:cache/cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () async {
    final Cache<int, String> cache = Cache<int, String>(ttl: 3);

    cache.add(1, 'first string');
    expect(cache.get(1) == 'first string', isTrue);
    await Future<void>.delayed(const Duration(seconds: 4));
    expect(cache.get(1), isNull);
  });

  test('should prune expired entries', () async {
    final Cache<int, String> cache = Cache<int, String>(ttl: 2);

    cache.add(1, 'first string');
    cache.add(2, 'second string');
    expect(cache.get(1) == 'first string', isTrue);
    expect(cache.get(2) == 'second string', isTrue);
    await Future<void>.delayed(const Duration(seconds: 3));
    expect(cache.get(1), isNull);
    expect(cache.get(2), isNull);
    expect(cache.length == 2, isTrue);
    cache.prune();
    expect(cache.length == 0, isTrue);
    expect(cache.get(1), isNull);
  });

  test('should clear all entries', () async {
    final Cache<int, String> cache = Cache<int, String>(ttl: 2);

    cache.add(1, 'first string');
    cache.add(2, 'second string');
    expect(cache.length == 2, isTrue);
    cache.clear();
    expect(cache.length == 0, isTrue);
    expect(cache.get(1), isNull);
  });

  test('should handle null parameters', () async {
    final Cache<int, String> cache = Cache<int, String>(ttl: 2);

    expect(cache.ttl == 2, isTrue);

    cache.ttl = null;
    expect(cache.ttl == 3600, isTrue);

    cache.ttl = 0;
    expect(cache.ttl == 0, isTrue);

    cache.ttl = -3;
    expect(cache.ttl == 3, isTrue);
  });

  test('should return null and expired values', () async {
    final Cache<int, String> cache = Cache<int, String>(ttl: 2);

    cache.ttl = 0;
    cache.add(1, 'value 1');
    expect(cache.get(1) == null, isTrue);
  });

  test('should return a valid list of entries', () async {
    final Cache<int, String> cache = Cache<int, String>();

    for (int i = 0; i < 10; i++) {
      cache.add(i, 'value $i');
    }

    expect(cache.length == 10, isTrue);

    for (final String entry in cache.entries) {
      expect(entry != null, isTrue);
    }

    final List<String> values = cache.entries.toList();
    expect(values.length == 10, isTrue);
  });
}
