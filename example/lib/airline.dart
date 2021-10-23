import 'package:equatable/equatable.dart';

class Airline extends Equatable {
  const Airline({
    this.country = '',
    this.established = '',
    this.headquarters = '',
    this.id = 0,
    this.logo = '',
    this.name = '',
    this.slogan = '',
    this.website = '',
  });

  factory Airline.fromMap(Map<String, dynamic> map) {
    return Airline(
      country: map['country'] as String? ?? '',
      established: map['established'] as String? ?? '',
      headquarters: map['headquarters'] as String? ?? '',
      id: map['id'] as int? ?? 0,
      logo: map['logo'] as String? ?? '',
      name: map['name'] as String? ?? '',
      slogan: map['slogan'] as String? ?? '',
      website: map['website'] as String? ?? '',
    );
  }

  final String country;
  final String established;
  final String headquarters;
  final int id;
  final String logo;
  final String name;
  final String slogan;
  final String website;

  @override
  List<Object> get props {
    return [
      country,
      established,
      headquarters,
      id,
      logo,
      name,
      slogan,
      website,
    ];
  }

  @override
  bool get stringify => true;
}
