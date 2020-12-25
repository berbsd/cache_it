import 'dart:developer' as developer;

import 'package:cache/cache.dart';

import 'airline.dart';
import 'api_provider.dart';

class Repository {
  final ApiProvider apiProvider = ApiProvider();

  // simple cache that contains individual airlines info
  final _cachedAirlines = Cache<int, Airline>();

  // fetch the complete list of airlines
  Future<List<Airline>> fetchAirlines() async {
    // check if the airlines are already cached
    List<Airline> airlines = _cachedAirlines.entries.toList();

    if (airlines.isNotEmpty) {
      // values were cached
      return airlines;
    }

    // no cached values - reloading
    developer.log('fetch airlines data online');

    airlines = await apiProvider.fetchAirlines();
    // caching each individual airline info separately
    for (final Airline airline in airlines) {
      _cachedAirlines.add(airline.id, airline);
    }
    return airlines;
  }

  Future<Airline> fetchAirline(int id) async {
    // check if the specific airline is cached already
    Airline airline = _cachedAirlines.get(id);
    if (airline != null) {
      developer.log('loading $id from cache');
      return airline;
    }
    // no cached value - reloading
    developer.log('fetch airline ($id) data online');

    airline = await apiProvider.fetchAirlineById(id);
    _cachedAirlines.add(airline.id, airline);
    return airline;
  }

  void clearCache() => _cachedAirlines.clear();
}
