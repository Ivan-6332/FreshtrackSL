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
  int _currentPage = 0;

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
          _currentPage = 1;
        });
      } else if (currentScroll <= threshold && _isShowingLowestDemand) {
        setState(() {
          _isShowingLowestDemand = false;
          _currentPage = 0;
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

    // Use full width for consistent card size with other places in the app
    final screenWidth = MediaQuery.of(context).size.width - 64;
    final cardWidth = screenWidth - 30; // Full width minus padding

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
                height: 100, // Fixed height to match the CropCard in other places
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Highest demand crop card
                    SizedBox(
                      width: cardWidth,
                      child: CropCard(crop: highestDemand),
                    ),

                    // Small gap between cards
                    const SizedBox(width: 15),

                    // Lowest demand crop card
                    SizedBox(
                      width: cardWidth,
                      child: CropCard(crop: lowestDemand),
                    ),

                    // Add padding at the end to allow full scrolling
                    const SizedBox(width: 20),
                  ],
                ),
              ),

              // Page indicator and swipe text (centered at bottom)
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Page indicator dots
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == 0 ?
                            Colors.red.shade700 :
                            Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == 1 ?
                            Colors.green.shade700 :
                            Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Swipe indicator text
                    GestureDetector(
                      onTap: _currentPage == 0 ? _scrollToLowestDemand : _scrollToHighestDemand,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == 0 ? 'Swipe for Lowest' : 'Swipe for Highest',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _currentPage == 0 ?
                              Colors.red.shade700 :
                              Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _currentPage == 0 ?
                            Icons.arrow_forward :
                            Icons.arrow_back,
                            color: _currentPage == 0 ?
                            Colors.red.shade700 :
                            Colors.green.shade700,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Small spacing at bottom
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}