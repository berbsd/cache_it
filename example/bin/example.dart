import 'dart:developer' as developer;

import 'package:example/repository.dart';
import 'package:example/airline.dart';

Future<void> main() async {
  final Repository repository = Repository();

  await repository.fetchAirlines();

  for (final int i in List.generate(10, (i) => i)) {
    final Airline airline = await repository.fetchAirline(i);
    developer.log('${airline.id}: ${airline.name}');
  }
}
