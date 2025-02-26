class City {
  final int? id;
  final String? name;
  const City({this.id, this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }

  // empty
  const City.empty()
      : id = null,
        name = null;
}
