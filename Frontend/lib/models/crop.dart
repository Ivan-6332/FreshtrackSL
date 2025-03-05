// lib/models/crop.dart
class Crop {
  final int id;
  final String name;
  final double demand;
  final bool isFavorited;
  final String category;

  Crop({
    required this.id,
    required this.name,
    required this.demand,
    required this.isFavorited,
    required this.category,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      demand: json['demand'].toDouble(),
      isFavorited: json['isFavorited'],
      category: json['category'],
    );
  }
}
