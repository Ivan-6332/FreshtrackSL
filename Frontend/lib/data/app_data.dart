// lib/data/app_data.dart
class AppData {
  static final List<Map<String, dynamic>> vegetables = [
    {
      "id": 1,
      "name": "Carrot",
      "demand": 145.5,
      "isFavorited": false,
      "category": "root vegetables"
    },
    {
      "id": 2,
      "name": "Tomato",
      "demand": 178.2,
      "isFavorited": true,
      "category": "fruiting vegetables"
    },
    {
      "id": 3,
      "name": "Beans",
      "demand": 92.8,
      "isFavorited": true,
      "category": "legumes & pods"
    },
    {
      "id": 4,
      "name": "Cabbage",
      "demand": 115.3,
      "isFavorited": false,
      "category": "cruciferous vegetables"
    },
    {
      "id": 5,
      "name": "Onion",
      "demand": 167.9,
      "isFavorited": true,
      "category": "bulb vegetables"
    }
  ];

  static final List<Map<String, dynamic>> categories = [
    {
      "name": "leafy greens",
      "icon": "🥬"
    },
    {
      "name": "root vegetables",
      "icon": "🥕"
    },
    {
      "name": "fruiting vegetables",
      "icon": "🍅"
    },
    {
      "name": "cruciferous vegetables",
      "icon": "🥦"
    },
    {
      "name": "legumes & pods",
      "icon": "🫘"
    },
    {
      "name": "bulb vegetables",
      "icon": "🧅"
    },
    {
      "name": "spices",
      "icon": "🌶️"
    },
    {
      "name": "grains",
      "icon": "🌾"
    }
  ];
}