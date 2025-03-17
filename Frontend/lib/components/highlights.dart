import 'package:flutter/material.dart';
import '../models/crop.dart';
import 'crop_card.dart';
import '../config/app_localizations.dart';

class Highlights extends StatefulWidget {
  final List<Crop> crops;

  const Highlights({super.key, required this.crops});

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    final sortedCrops = List<Crop>.from(widget.crops)
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
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified header with lighter combined background for icon and text
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
                            Icons.trending_up,
                            color: Colors.green.shade700,
                            size: 27,
                          ),

                          const SizedBox(width: 10),

                          // Text section with reduced font size
                          Text(
                            localizations.get('highlights') ?? 'Highlights',
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

                      // Toggle icon
                      Icon(
                        _showDescription ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.green.shade700,
                        size: 27,
                      ),
                    ],
                  ),
                ),
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
                        'In here you can see the crop that have the highest demand and the lowest demand today.',
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

          // Highest demand label with reduced sizing
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_circle_up,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Highest Demand',
                    style: TextStyle(
                      fontSize: 14,
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
                ],
              ),
            ),
          ),

          // Highest demand crop card - slightly reduced scale
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Transform.scale(
              scale: 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CropCard(crop: highestDemand),
              ),
            ),
          ),

          // Lowest demand label with reduced sizing
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_circle_down,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lowest Demand',
                    style: TextStyle(
                      fontSize: 14,
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
                ],
              ),
            ),
          ),

          // Lowest demand crop card - reduced scale
          Transform.scale(
            scale: 0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CropCard(crop: lowestDemand),
            ),
          ),

          // Reduced extra space
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}