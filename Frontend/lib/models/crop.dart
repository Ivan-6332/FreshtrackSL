// lib/models/crop.dart
class Crop {
  final int id;
  final String name;
  final double demand;
  final bool isFavorited;
  final String category;
  final String pic;

  Crop({
    required this.id,
    required this.name,
    required this.demand,
    required this.isFavorited,
    required this.category,
    required this.pic,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      demand: json['demand'].toDouble(),
      isFavorited: json['isFavorited'] ?? false,
      category: json['category'],
      pic: json['pic'],
    );
  }
}
