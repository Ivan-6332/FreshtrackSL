import 'package:flutter/material.dart';
import '../models/crop.dart';
import '../config/app_localizations.dart';

class CropCard extends StatefulWidget {
  final Crop crop;

  const CropCard({super.key, required this.crop});

  @override
  State<CropCard> createState() => _CropCardState();
}

class _CropCardState extends State<CropCard> {
  bool _isHovered = false;

  String getCropIcon() {
    switch (widget.crop.name.toLowerCase()) {
      case 'carrot':
        return '🥕';
      case 'tomato':
        return '🍅';
      case 'beans':
        return '🫘';
      case 'cabbage':
        return '🥬';
      case 'onion':
        return '🧅';
      default:
        return '🌱';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // Calculate percentage of demand relative to max (200%)
    final demandPercentage = widget.crop.demand / 200;
    final isHighDemand = widget.crop.demand > 100;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuad,
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.05)) // Scale up when hovered/touched
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.shade300,
                Colors.green.shade500,
                Colors.teal.shade400,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(_isHovered ? 0.5 : 0.3),
                offset: Offset(0, _isHovered ? 8 : 4),
                blurRadius: _isHovered ? 12 : 8,
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0), // Border thickness
            child: Card(
              elevation: 0, // No elevation for the inner card
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Increased crop icon size
                          Text(
                            getCropIcon(),
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.crop.name,
                              style: const TextStyle(
                                fontSize: 20, // Increased crop name size
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          // 3D Circular progress indicator for crop demand
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Make the circle size responsive
                              final size = constraints.maxWidth * 0.2;
                              return SizedBox(
                                width: size < 62 ? size : 62,
                                height: size < 62 ? size : 62,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Drop shadow for 3D effect
                                    Container(
                                      width: size < 58 ? size - 4 : 58,
                                      height: size < 58 ? size - 4 : 58,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Circular progress background (track)
                                    Container(
                                      width: size < 58 ? size - 4 : 58,
                                      height: size < 58 ? size - 4 : 58,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.grey.shade100,
                                            Colors.grey.shade300,
                                          ],
                                          stops: const [0.7, 1.0],
                                        ),
                                      ),
                                    ),
                                    // Circular progress indicator
                                    TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: demandPercentage),
                                      duration: const Duration(milliseconds: 1500),
                                      curve: Curves.easeOutQuart,
                                      builder: (context, value, _) {
                                        return ShaderMask(
                                          shaderCallback: (rect) {
                                            return SweepGradient(
                                              startAngle: -0.5 * 3.14,
                                              endAngle: 1.5 * 3.14,
                                              stops: [value, value],
                                              colors: [
                                                isHighDemand ?
                                                Colors.green.shade700 :
                                                Colors.red.shade700,
                                                Colors.transparent,
                                              ],
                                            ).createShader(rect);
                                          },
                                          child: Container(
                                            width: size < 58 ? size - 4 : 58,
                                            height: size < 58 ? size - 4 : 58,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.transparent,
                                                width: 4,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    // Inner circle with 3D effect
                                    Container(
                                      width: size < 48 ? size - 12 : 48,
                                      height: size < 48 ? size - 12 : 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: isHighDemand ?
                                          [Colors.green.shade50, Colors.green.shade200] :
                                          [Colors.red.shade50, Colors.red.shade200],
                                          center: const Alignment(-0.3, -0.3),
                                          focal: const Alignment(-0.5, -0.5),
                                          focalRadius: 0.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (isHighDemand ? Colors.green : Colors.red).withOpacity(0.3),
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.8),
                                            offset: const Offset(-1, -1),
                                            blurRadius: 2,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Demand percentage text with improved visibility
                                    Text(
                                      '${widget.crop.demand.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        color: isHighDemand ?
                                        Colors.green.shade900 :
                                        Colors.red.shade900,
                                        fontSize: size < 48 ? size * 0.25 : 13,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 0.5),
                                            blurRadius: 1,
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Smaller button with same text size
                      SizedBox(
                        width: double.infinity,
                        height: 46, // Smaller button height
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.green.shade400,
                                Colors.teal.shade400,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10), // Reduced vertical padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // Makes the row tighter
                              children: [
                                Text(
                                  localizations.get('viewHistory'),
                                  style: const TextStyle(
                                    fontSize: 15, // Maintained the same text size
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                        color: Color.fromRGBO(0, 0, 0, 0.3),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}