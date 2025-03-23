import 'package:flutter/material.dart';
import '../models/crop.dart';
import 'crop_card.dart';
import '../config/app_localizations.dart';
import 'package:intl/intl.dart';

class Highlights extends StatefulWidget {
  final List<Crop> crops;

  const Highlights({super.key, required this.crops});

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
  bool _showDescription = false;
  final ScrollController _scrollController = ScrollController();
  bool _isShowingLowestDemand = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Check if we're closer to the end than the beginning
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final threshold = maxScroll * 0.4; // 40% threshold

      // Update state based on scroll position
      if (currentScroll > threshold && !_isShowingLowestDemand) {
        setState(() {
          _isShowingLowestDemand = true;
        });
      } else if (currentScroll <= threshold && _isShowingLowestDemand) {
        setState(() {
          _isShowingLowestDemand = false;
        });
      }
    }
  }

  void _scrollToLowestDemand() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToHighestDemand() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedCrops = List<Crop>.from(widget.crops)
      ..sort((a, b) => b.demand.compareTo(a.demand));

    final highestDemand = sortedCrops.first;
    final lowestDemand = sortedCrops.last;

    final localizations = AppLocalizations.of(context);
    final today = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(today);

    // Responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.7; // 70% of screen width

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
              // Transparent header with no border

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
                    // Removed decoration to make it transparent with no borders
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
                            "Here's the crops with the highest & lowest demand for the selected week!",
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

              // Dynamic demand label that changes based on scroll
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  key: ValueKey<bool>(_isShowingLowestDemand),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          _isShowingLowestDemand ? Icons.arrow_circle_down : Icons.arrow_circle_up,
                          color: _isShowingLowestDemand ? Colors.red.shade700 : Colors.green.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isShowingLowestDemand ? 'Lowest Demand' : 'Highest Demand',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _isShowingLowestDemand ? Colors.red.shade800 : Colors.green.shade800,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 1,
                                color: _isShowingLowestDemand ?
                                Colors.red.withOpacity(0.3) :
                                Colors.green.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Horizontal scrollable cards
              SizedBox(
                height: 200, // Adjust based on your actual card height
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Highest demand crop card
                    SizedBox(
                      width: cardWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CropCard(crop: highestDemand),
                      ),
                    ),

                    // Small gap between cards
                    const SizedBox(width: 15),

                    // Lowest demand crop card
                    SizedBox(
                      width: cardWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CropCard(crop: lowestDemand),
                      ),
                    ),

                    // Add padding at the end to allow full scrolling
                    const SizedBox(width: 20),
                  ],
                ),
              ),

              // Small spacing at bottom
              const SizedBox(height: 18),
            ],
          ),
        ),

        // Dynamic navigation indicator - changes based on scroll position
        // Show highest demand indicator when at lowest demand
        if (_isShowingLowestDemand)
          Positioned(
            bottom: 15,
            left: 25, // Positioned at bottom left
            child: GestureDetector(
              onTap: _scrollToHighestDemand,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,  // Fixed: changed from arrow_backward to arrow_back
                    color: Colors.green.shade800,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Highest',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_circle_up,
                    color: Colors.green.shade800,
                    size: 16,
                  ),
                ],
              ),
            ),
          )

        // Show lowest demand indicator when at highest demand
        else
          Positioned(
            bottom: 15,
            right: 25, // Positioned at bottom right
            child: GestureDetector(
              onTap: _scrollToLowestDemand,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_circle_down,
                    color: Colors.red.shade800,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Lowest',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade900,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.red.shade800,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}