# cache

A simple cache package.


###  Install Dependencies 

Add the following to your pubspec.yaml:
```
dependencies:
  cache:
    git:
      url: https://github.com/berbsd/flutter-cache.git
```

Add a Cache<K,V> object to your class by specifying the key (K) and the value type V.   

```dart
import 'package:cache/cache.dart';

class ActivityRepository {
  // instantiate a cache with 10 min ttl for objects
  final Cache<int, Activity> _cache = Cache<int, Activity>(ttl: 600);

  Activity getActivityById(int id) async {
    // retrieving a cached value, returns null if absent or expired
    Activity activity = _cache.get(id);
    if(activity == null) {
      // fetch a new value from API
      activity = http.get('$url/$id');
      // cache the newly retrieved value
      _cache.add(id, activity);
    }
    return activity;
  }
}
```

