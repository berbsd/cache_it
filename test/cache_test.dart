import 'package:cache_it/cache_it.dart';
import 'package:test/test.dart';

void main() {
  test('adds one to input values', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 3);

    cache.add(1, 'first string');
    expect(cache.get(1) == 'first string', isTrue);
    await Future<void>.delayed(const Duration(seconds: 4));
    expect(cache.get(1), isNull);
  });

  test('should prune expired entries', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 2);

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
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 2);

    cache.add(1, 'first string');
    cache.add(2, 'second string');
    expect(cache.length == 2, isTrue);
    cache.clear();
    expect(cache.length == 0, isTrue);
    expect(cache.get(1), isNull);
  });

  test('should handle null parameters', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 2);

    expect(cache.ttl == 2, isTrue);

    cache.ttl = 0;
    expect(cache.ttl == 0, isTrue);

    cache.ttl = -3;
    expect(cache.ttl == 3, isTrue);
  });

  test('should return null and expired values', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 2);

    cache.ttl = 0;
    cache.add(1, 'value 1');
    expect(cache.get(1) == null, isTrue);
  });

  test('should return a valid list of entries', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>();

    for (int i = 0; i < 10; i++) {
      cache.add(i, 'value $i');
    }

    expect(cache.length == 10, isTrue);

    final List<String?> values = cache.entries.toList();
    expect(values.length == 10, isTrue);
  });

  test('should return a valid list of entries', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 2);

    for (int i = 0; i < 10; i++) {
      cache.add(i, 'value $i');
    }

    await Future<void>.delayed(const Duration(seconds: 3));

    expect(cache.length == 10, isTrue);

    final List<String> values1 = cache.entries.toList();
    expect(values1, isEmpty);
    cache.add(50, 'value 50');
    final List<String> values2 = cache.entries.toList();

    expect(values2.length == 1, isTrue);
  });

  test('should prevent adding a duplicate entry', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>();

    for (int i = 0; i < 10; i++) {
      cache.add(i, 'value $i');
    }

    expect(cache.length == 10, isTrue);

    cache.add(1, 'value 1');

    expect(cache.length == 10, isTrue);
  });
}
