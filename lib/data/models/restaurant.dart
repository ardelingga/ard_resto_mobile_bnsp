class Restaurant {
  final int? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? city;
  final String? location;
  final double? rating;
  final String? createdAt;
  final String? updatedAt;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.city,
    this.location,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  Restaurant.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        description = json['description'] as String?,
        imageUrl = json['image_url'] as String?,
        city = json['city'] as String?,
        location = json['location'] as String?,
        rating = json['rating'] != null
            ? (json['rating'] is int
                ? (json['rating'] as int).toDouble()
                : json['rating'] as double)
            : null,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'city': city,
        'location': location,
        'rating': rating,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
