import 'package:flutter/material.dart';
import '../models/crop.dart';
import 'crop_card.dart';
import '../config/app_localizations.dart';

class Highlights extends StatelessWidget {
  final List<Crop> crops;

  const Highlights({super.key, required this.crops});

  @override
  Widget build(BuildContext context) {
    final sortedCrops = List<Crop>.from(crops)
      ..sort((a, b) => b.demand.compareTo(a.demand));

    final highestDemand = sortedCrops.first;
    final lowestDemand = sortedCrops.last;

    final localizations = AppLocalizations.of(context);

    return Container(
      // Light green gradient background
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50.withOpacity(0.8),
            Colors.green.shade100.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified header with lighter combined background for icon and text
          Padding(
            padding: const EdgeInsets.only(bottom: 36), // Increased bottom padding
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade50.withOpacity(0.5), // Even lighter background
                    Colors.green.shade100.withOpacity(0.3), // Even lighter background
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15), // Slightly more pronounced shadow
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: Colors.green.shade200.withOpacity(0.9), // More visible border
                  width: 1.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon in the same container as text - increased size
                    Icon(
                      Icons.trending_up,
                      color: Colors.green.shade700,
                      size: 33, // Increased from 32
                    ),

                    const SizedBox(width: 16),

                    // Text section with increased font size
                    Text(
                      localizations.get('highlights') ?? 'Highlights',
                      style: TextStyle(
                        fontSize: 28, // Increased from 28
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
              ),
            ),
          ),

          // Highest demand label with emoji
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_circle_up,
                    color: Colors.green.shade700,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Highest Demand',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade800,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 1,
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  // Removed the fire emoji and Spacer
                ],
              ),
            ),
          ),

          // Highest demand crop card
          Padding(
            padding: const EdgeInsets.only(bottom: 40), // Increased padding to 40
            child: Transform.scale(
              scale: 1.05,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CropCard(crop: highestDemand),
              ),
            ),
          ),

          // Lowest demand label with emoji
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_circle_down,
                    color: Colors.red.shade700,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Lowest Demand',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade800,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 1,
                          color: Colors.red.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  // Removed the chart decreasing emoji and Spacer
                ],
              ),
            ),
          ),

          // Lowest demand crop card
          Transform.scale(
            scale: 1.05,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CropCard(crop: lowestDemand),
            ),
          ),

          // Extra space after the component
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}