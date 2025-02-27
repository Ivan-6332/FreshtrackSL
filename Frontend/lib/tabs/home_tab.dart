// lib/screens/tabs/home_tab.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../models/crop.dart';
import '../../components/greeting.dart';
import '../../components/search_bar.dart';
import '../../components/highlights.dart';
import '../../components/favorites.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Crop> crops = [];

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    // In a real app, you would load from assets
    // For now, we'll hardcode the data
    final jsonData = [
      {"id": 1, "name": "Carrot", "demand": 145.5, "isFavorited": false},
      {"id": 2, "name": "Tomato", "demand": 178.2, "isFavorited": true},
      {"id": 3, "name": "Beans", "demand": 92.8, "isFavorited": true},
      {"id": 4, "name": "Cabbage", "demand": 115.3, "isFavorited": false},
      {"id": 5, "name": "Onion", "demand": 167.9, "isFavorited": true}
    ];

    setState(() {
      crops = jsonData.map((json) => Crop.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48), // For status bar
          const Greeting(),
          const SearchBarWithProfile(),
          const SizedBox(height: 24),
          Highlights(crops: crops),
          const SizedBox(height: 24),
          Favorites(crops: crops),
        ],
      ),
    );
  }
}