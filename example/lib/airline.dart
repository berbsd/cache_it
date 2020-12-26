class Airline {
  const Airline({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.slogan,
    required this.headquarters,
    required this.website,
    required this.established,
  });

  factory Airline.fromMap(Map<String, dynamic> map) {
    return Airline(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      logo: map['logo'] ?? '',
      slogan: map['slogan'] ?? '',
      headquarters: map['head_quaters'] ?? '',
      website: map['website'] ?? '',
      established: map['established'] ?? 'unknown',
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
}
