import 'package:flutter/material.dart';
import '../models/crop.dart';
import 'crop_card.dart';
import '../config/app_localizations.dart';

class Favorites extends StatefulWidget {
  final List<Crop> crops;

  const Favorites({super.key, required this.crops});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool _showDescription = false;

  void _showFavoritesPopup(List<Crop> favoriteCrops) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade50,
                  Colors.green.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: Colors.green.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.green.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Favorite Crops',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.green.shade700,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Simple list of favorite crop names
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: favoriteCrops.length,
                  itemBuilder: (context, index) {
                    final crop = favoriteCrops[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        crop.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade800,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteCrops = widget.crops.where((crop) => crop.isFavorited).toList();
    final localizations = AppLocalizations.of(context);

    return Container(
      // Light green gradient background matching Highlights
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50.withOpacity(0.8),
            Colors.green.shade100.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified header with transparent background
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showDescription = !_showDescription;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green.shade50.withOpacity(0.5),
                        Colors.green.shade100.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.shade200.withOpacity(0.9),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon with reduced size
                            Icon(
                              Icons.favorite,
                              color: Colors.green.shade700,
                              size: 27,
                            ),

                            const SizedBox(width: 10),

                            // Text section with reduced font size
                            Text(
                              localizations.get('favorites'),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                letterSpacing: 0.2,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.green.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            // Favorites Counter - still with styling but content preserved
                            GestureDetector(
                              onTap: () => _showFavoritesPopup(favoriteCrops),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.green.shade300.withOpacity(0.8),
                                      Colors.green.shade400.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "${favoriteCrops.length}/5",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Toggle icon
                            Icon(
                              _showDescription ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.green.shade700,
                              size: 27,
                            ),
                          ],
                        ),
                      ],
                    ),
              )

              ),
            ),
          ),

          // Animated collapsible description text
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showDescription ? null : 0,
            child: AnimatedOpacity(
              opacity: _showDescription ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _showDescription ? Container(
                margin: const EdgeInsets.only(bottom: 16, left: 2, right: 2),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade100.withOpacity(0.4),
                      Colors.green.shade50.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.shade300.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.green.shade800,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Here's your favorite crops and their insights for the selected week!",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ) : const SizedBox.shrink(),
            ),
          ),

          // Favorite crop cards WITHOUT scaling transformation - this is the key change
          ...favoriteCrops.asMap().entries.map((entry) {
            final index = entry.key;
            final crop = entry.value;
            final isLast = index == favoriteCrops.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CropCard(crop: crop),
              ),
            );
          }).toList(),

          // Reduced extra space after the component
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}