import 'package:flutter/material.dart';
import '../models/crop.dart';
import '../config/app_localizations.dart';
import '../components/crop_popup.dart';

class CropCard extends StatefulWidget {
  final Crop crop;

  const CropCard({super.key, required this.crop});

  @override
  State<CropCard> createState() => _CropCardState();
}

class _CropCardState extends State<CropCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // Calculate percentage of demand relative to max (200%)
    final demandPercentage = widget.crop.demand / 200;
    final isHighDemand = widget.crop.demand > 70;

    // Define demand color based on value
    final Color demandColor = isHighDemand ? Colors.green.shade700 : Colors.red.shade700;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        onTap: () {
          // Show the popup when the card is tapped
          showDialog(
            context: context,
            builder: (context) => CropPopup(crop: widget.crop),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuad,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          // transform: _isHovered
          //     ? (Matrix4.identity()..scale(1.05)) // Scale up when hovered/touched
          //     : Matrix4.identity(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0), // Reduced vertical padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Crop emoji - made smaller
                      Container(
                        width: 40, // Reduced from 60
                        height: 40, // Reduced from 60
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            widget.crop.pic,
                            style: const TextStyle(fontSize: 30), // Reduced from 32
                          ),
                        ),
                      ),

                      const SizedBox(width: 12), // Reduced spacing

                      // Crop name and category in a column - taking only needed space
                      Expanded(
                        flex: 2, // Give more space to the name/category column
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Crop name
                            Text(
                              widget.crop.name,
                              style: const TextStyle(
                                fontSize: 17, // Reduced from 18
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            // Category with limited space
                            Text(
                              widget.crop.category,
                              style: TextStyle(
                                fontSize: 12, // Reduced from 14
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Spacer to push demand info to right
                      const Spacer(flex: 1),

                      // Demand graph and value
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Animated demand graph
                          Container(
                            width: 50, // Reduced from 70
                            height: 30, // Reduced from 40
                            padding: const EdgeInsets.all(3),
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return CustomPaint(
                                  size: const Size(44, 24), // Adjusted size
                                  painter: ZigzagDemandGraphPainter(
                                    demandPercentage: demandPercentage,
                                    animationValue: _lineAnimation.value,
                                    isHighDemand: isHighDemand,
                                    demandColor: demandColor,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 4),

                          // Demand value with label
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Demand :',
                                style: TextStyle(
                                  fontSize: 12, // Small label
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              Text(
                                '${widget.crop.demand.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 17, // Reduced from 16
                                  color: demandColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
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

class ZigzagDemandGraphPainter extends CustomPainter {
  final double demandPercentage;
  final double animationValue;
  final bool isHighDemand;
  final Color demandColor;

  ZigzagDemandGraphPainter({
    required this.demandPercentage,
    required this.animationValue,
    required this.isHighDemand,
    required this.demandColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw X and Y axis
    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Y-axis
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, size.height),
      axisPaint,
    );

    // X-axis
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );

    // Draw zigzag demand line
    final linePaint = Paint()
      ..color = demandColor
      ..strokeWidth = 2.0 // Reduced from 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Start at origin
    path.moveTo(0, size.height);

    // Calculate how far along the x-axis to draw based on animation
    final maxX = size.width * animationValue;

    // For zigzag pattern, we'll create exactly 3 line segments
    const segmentCount = 3;

    // Starting height for the zigzag (represents overall trend)
    final trendHeight = isHighDemand
        ? size.height * (1 - demandPercentage) // High demand trends upward
        : size.height * 0.9; // Low demand trends flat/slightly downward

    // Height of zigzag variation
    final zigzagAmplitude = size.height * 0.15;

    // Define points for zigzag - exactly 4 points for 3 lines
    List<Offset> points = [];

    // Starting point
    points.add(Offset(0, size.height));

    // Generate exactly 3 line segments
    for (int i = 1; i <= segmentCount; i++) {
      final progress = i / segmentCount;
      final x = size.width * progress;

      // Skip points beyond our animation progress
      if (x > maxX) break;

      // Calculate y with zigzag pattern and overall trend
      double y;

      if (isHighDemand) {
        // For high demand: zigzag with upward trend
        final baseY = size.height - (size.height - trendHeight) * progress;
        // Alternate up and down for the zigzag effect
        final zigzagOffset = i.isOdd ? -zigzagAmplitude : zigzagAmplitude;
        y = baseY + zigzagOffset;

        // Make sure the last point is at the top for high demand
        if (i == segmentCount) {
          y = baseY - zigzagAmplitude; // Force last point to be at the top
        }
      } else {
        // For low demand: zigzag with downward trend
        final baseY = size.height + (trendHeight - size.height) * progress;
        // Alternate up and down for the zigzag effect
        final zigzagOffset = i.isOdd ? zigzagAmplitude : -zigzagAmplitude;
        y = baseY + zigzagOffset;

        // Make sure the last point is at the bottom for low demand
        if (i == segmentCount) {
          y = baseY + zigzagAmplitude; // Force last point to be at the bottom
        }
      }

      // Ensure y stays within bounds
      y = y.clamp(3.0, size.height - 3.0); // Reduced from 5.0
      points.add(Offset(x, y));
    }

    // Add endpoint if needed due to animation cutoff
    if (animationValue < 1.0 && points.length > 1) {
      // Find the two points around the animation cutoff
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i].dx <= maxX && points[i + 1].dx > maxX) {
          // Interpolate to find the exact cutoff point
          final ratio = (maxX - points[i].dx) / (points[i + 1].dx - points[i].dx);
          final y = points[i].dy + (points[i + 1].dy - points[i].dy) * ratio;
          points = points.sublist(0, i + 1); // Keep only points up to i
          points.add(Offset(maxX, y)); // Add the cutoff point
          break;
        }
      }
    }

    // Draw the path
    if (points.length > 1) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(path, linePaint);
    }

    // Draw small tick marks on the axes
    final tickPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0;

    // X-axis ticks
    for (int i = 1; i <= 2; i++) { // Reduced from 3 to 2 ticks
      final x = size.width * (i / 2);
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - 2),
        tickPaint,
      );
    }

    // Y-axis ticks
    for (int i = 1; i <= 2; i++) { // Reduced from 3 to 2 ticks
      final y = size.height * (i / 2);
      canvas.drawLine(
        Offset(0, y),
        Offset(2, y),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ZigzagDemandGraphPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.demandPercentage != demandPercentage;
  }
}