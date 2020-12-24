import 'package:cache/cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CacheManager cacheManager;

  setUpAll(() => cacheManager = CacheManager());
  test('should prune expired values', () async {
    final CacheManager cacheManager = CacheManager();

    final Cache<int, String> cache1 = Cache<int, String>(ttl: 2);
    cacheManager.add(cache1);

    cache1.add(1, 'string 1');
    cache1.add(2, 'string 2');
    expect(cache1.entries, 2);

    final Cache<String, int> cache2 = Cache<String, int>(ttl: 2);
    cacheManager.add(cache2);

    cache2.add('string 1', 1);
    cache2.add('string 2', 2);
    expect(cache1.entries, 2);

    await Future<void>.delayed(const Duration(seconds: 3));

    cacheManager.prune();
    expect(cache1.entries, 0);
    expect(cache2.entries, 0);
  });

  test('should prevent duplicate caches', () async {
    final CacheManager cacheManager = CacheManager();

    final Cache<int, String> cache1 = Cache<int, String>(ttl: 0);
    cacheManager.add(cache1);
    cache1.add(1, 'string 1');

    expect(() => cacheManager.add(cache1), throwsA(isInstanceOf<DuplicateEntryException>()));
    expect(cache1.get(1), isNull);
  });

  tearDownAll(() => cacheManager.dispose());
}
