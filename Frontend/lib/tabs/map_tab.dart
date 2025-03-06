// lib/screens/tabs/map_tab.dart
import 'package:flutter/material.dart';
import '../config/app_localizations.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Text(localizations.get('mapTabContent')),
    );
  }
}
