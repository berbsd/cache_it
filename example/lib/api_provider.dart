import 'dart:convert';

import 'package:http/http.dart' as http;

import 'airline.dart';

class ApiProvider {
  final String baseUrl = 'https://api.instantwebtools.net/v1';

  Future<List<Airline>> fetchAirlines() async {
    final http.Response response = await http.get('$baseUrl/airlines');
    return (response.statusCode != 200)
        ? <Airline>[]
        : List<Map<String, dynamic>>.from(json.decode(response.body)).map((m) => Airline.fromMap(m)).toList();
  }

  Future<Airline> fetchAirlineById(int id) async {
    final http.Response response = await http.get('$baseUrl/airlines/$id');
    return (response.statusCode != 200) ? null : Airline.fromMap(json.decode(response.body));
  }
}
