import 'package:cache_it/cache_it.dart';
import 'package:test/test.dart';

void main() {
  CacheManager? cacheManager;

  setUpAll(() => cacheManager = CacheManager());
  test('should prune expired values', () async {
    final CacheManager cacheManager = CacheManager();

    final CacheIt<int, String> cache1 = CacheIt<int, String>(ttl: 2);
    cacheManager.add(cache1);

    cache1.add(1, 'string 1');
    cache1.add(2, 'string 2');
    expect(cache1.length, 2);

    final CacheIt<String, int> cache2 = CacheIt<String, int>(ttl: 2);
    cacheManager.add(cache2);

    cache2.add('string 1', 1);
    cache2.add('string 2', 2);
    expect(cache1.length, 2);

    await Future<void>.delayed(const Duration(seconds: 3));

    cacheManager.prune();
    expect(cache1.length, 0);
    expect(cache2.length, 0);
  });

  test('should prevent duplicate caches', () async {
    final CacheManager cacheManager = CacheManager();

    final CacheIt<int, String> cache1 = CacheIt<int, String>(ttl: 0);
    cacheManager.add(cache1);
    cache1.add(1, 'string 1');

    expect(() => cacheManager.add(cache1), throwsA(isA<DuplicateEntryException>()));
    expect(cache1.get(1), isNull);
  });

  tearDownAll(() => cacheManager?.dispose());
}
