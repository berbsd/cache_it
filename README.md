# cache_it

A simple cache package.


###  Install Dependencies 

Add the following to your pubspec.yaml:
```
dependencies:
  cache_it:
    git:
      url: https://github.com/berbsd/flutter-cache.git
```

Add a Cache<K,V> object to your class by specifying the key (K) and the value type V.   

```dart
import 'package:cache_it/cache_it.dart';

class ActivityRepository {
  // instantiate a cache with 10 min ttl for objects
  final CacheIt<int, Activity> _cache = CacheIt<int, Activity>(ttl: 600);

  Activity getActivityById(int id) async {
    // retrieving a cached value, returns null if absent or expired
    return _cache.getOrUpdate(id, builder: () => await http.get('$url/$id'));
}
```

Other example

```dart
import 'package:cache_it/cache_it.dart';

class ActivityRepository {
  // instantiate a cache with 10 min ttl for objects
  final CacheIt<int, Activity> _cache = CacheIt<int, Activity>(ttl: 600);

  Activity getActivityById(int id) async {
    // retrieving a cached value, returns null if absent or expired
    Activity activity = _cache.get(id);
    if(activity == null) {
      // fetch a new value from API
      activity = await http.get('$url/$id');
      // cache the newly retrieved value
      _cache.add(id, activity);
    }
    return activity;
  }
}
```


