class Airline {
  const Airline({
    this.id,
    this.name,
    this.country,
    this.logo,
    this.slogan,
    this.headquarters,
    this.website,
    this.established,
  });

  factory Airline.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

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
