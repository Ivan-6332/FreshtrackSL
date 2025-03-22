// lib/models/crop.dart
class Crop {
  final String id;
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
      id: json['crop_id'].toString(),
      name: json['crop_name'] ?? json['name'] ?? '',
      demand: json['demand'] == null
          ? 0.0
          : (json['demand'] is double
              ? json['demand']
              : (json['demand'] is int ? json['demand'].toDouble() : 0.0)),
      isFavorited: json['isFavorited'] ?? false,
      category: json['crop_category'] ?? json['category'] ?? '',
      pic: json['crop_pic'] ?? json['pic'] ?? '🌱',
    );
  }
}
