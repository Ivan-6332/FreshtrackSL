// lib/screens/tabs/home_tab.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../data/app_data.dart';
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

  void _loadCrops() {
    setState(() {
      crops = AppData.vegetables.map((json) => Crop.fromJson(json)).toList();
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