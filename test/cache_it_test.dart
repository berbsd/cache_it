import 'dart:developer' as developer;

import 'package:cache_it/cache_it.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('should upgrade the value and reset expiration', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>();

    for (int i = 0; i < 10; i++) {
      cache.add(i, 'value $i');
    }

    expect(cache.length == 10, isTrue);

    for (final String? entry in cache.entries) {
      expect(entry != null, isTrue);
    }

    developer.log(cache.toString());
    await Future<void>.delayed(const Duration(seconds: 5));
    cache.add(1, 'value A');

    developer.log(cache.toString());

    expect(cache.get(1) == 'value A', isTrue);
  });

  test('validate getOrUpdate function with sync functions', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 3);

    const String initialValue = 'initial value';

    cache.add(1, initialValue);

    final String? value1 = await cache.getOrUpdate(
      1,
      () async => 'random ${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
    );

    // should return the same initial value.
    expect(value1 == initialValue, isTrue);

    // leaving the cache to expire
    await Future<void>.delayed(const Duration(seconds: 3));

    final String? value2 = await cache.getOrUpdate(
      1,
      () async => '${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
    );

    expect(value2, isNotNull);
    expect(value2 != 'initial value', isTrue);

    final String? value3 = await cache.getOrUpdate(
      2,
      () async => '${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
    );
    final String? value4 = await cache.getOrUpdate(
      2,
      () async => '${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
    );

    expect(value3, isNotNull);
    expect(value4, isNotNull);
    expect(value3 == value4, isTrue);
  });

  test('validate getOrUpdate function with async functions', () async {
    final CacheIt<int, String> cache = CacheIt<int, String>(ttl: 3);

    Future<String> builder() {
      return Future<String>.delayed(
        const Duration(seconds: 1),
        () => 'random ${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
      );
    }

    const String initialValue = 'initial value';

    cache.add(1, initialValue);

    final String? value1 = await cache.getOrUpdate(1, builder);

    // should return the same initial value.
    expect(value1 == initialValue, isTrue);

    // leaving the cache to expire
    await Future<void>.delayed(const Duration(seconds: 3));

    final String? value2 = await cache.getOrUpdate(1, builder);

    expect(value2, isNotNull);
    expect(value2 != 'initial value', isTrue);

    final String? value3 = await cache.getOrUpdate(2, builder);
    final String? value4 = await cache.getOrUpdate(2, builder);

    expect(value3, isNotNull);
    expect(value4, isNotNull);
    expect(value3 == value4, isTrue);
  });
}
