import 'package:flutter/material.dart';
import '../models/crop.dart';
import '../config/app_localizations.dart';

class CropCard extends StatefulWidget {
  final Crop crop;

  const CropCard({super.key, required this.crop});

  @override
  State<CropCard> createState() => _CropCardState();
}

class _CropCardState extends State<CropCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _arrowGrowAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animation for arrow growing continuously from base without reversing
    _arrowGrowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        // Use a custom curve that grows and then resets instantly
        curve: const _GrowAndResetCurve(),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start continuous animation
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
              ? (Matrix4.identity()..scale(1.05))
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
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
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
                          Text(
                            getCropIcon(),
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.crop.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          // Responsive Dynamic Growing Arrow Animation
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Make arrow size responsive
                              final double containerWidth = constraints.maxWidth;
                              final double size = MediaQuery.of(context).size.width < 600
                                  ? containerWidth * 0.22  // Smaller screens
                                  : containerWidth * 0.18; // Larger screens
                              final double arrowSize = size < 62 ? size : 62;

                              return SizedBox(
                                width: arrowSize,
                                height: arrowSize,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Demand percentage text container
                                        Positioned(
                                          bottom: isHighDemand ? 2 : null,
                                          top: isHighDemand ? null : 2,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: arrowSize * 0.1,
                                              vertical: arrowSize * 0.03,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 1,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              '${widget.crop.demand.toStringAsFixed(1)}%',
                                              style: TextStyle(
                                                color: isHighDemand
                                                    ? Colors.green.shade900
                                                    : Colors.red.shade900,
                                                fontSize: arrowSize * 0.21,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Growing Arrow
                                        Positioned(
                                          bottom: isHighDemand ? arrowSize * 0.32 : null,
                                          top: isHighDemand ? null : arrowSize * 0.32,
                                          child: Transform(
                                            alignment: isHighDemand ? Alignment.bottomCenter : Alignment.topCenter,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.001) // perspective
                                              ..rotateX(isHighDemand ? 0.1 : -0.1)
                                              ..rotateY(_rotationAnimation.value)
                                              ..scale(_scaleAnimation.value),
                                            child: ClipRect(
                                              child: Align(
                                                alignment: isHighDemand ? Alignment.bottomCenter : Alignment.topCenter,
                                                heightFactor: _arrowGrowAnimation.value,
                                                child: CustomPaint(
                                                  size: Size(arrowSize * 0.7, arrowSize * 0.7),
                                                  painter: GrowingArrowPainter(
                                                    isUpArrow: isHighDemand,
                                                    color: isHighDemand
                                                        ? Colors.green.shade700
                                                        : Colors.red.shade700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  localizations.get('viewHistory'),
                                  style: const TextStyle(
                                    fontSize: 15,
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

// Custom curve that grows from 0 to 1 and then instantly resets
class _GrowAndResetCurve extends Curve {
  const _GrowAndResetCurve();

  @override
  double transformInternal(double t) {
    // Divide the animation into segments:
    // - 0.0-0.9: Grow from 0% to 100%
    // - 0.9-1.0: Reset to 0% (instantly)
    if (t < 0.9) {
      // Scale t from 0-0.9 to 0-1 for smooth growth
      return t / 0.9;
    } else {
      // Reset to 0 instantly for the remaining 10% of the animation time
      return 0.0;
    }
  }
}

// Custom painter for growing arrow
class GrowingArrowPainter extends CustomPainter {
  final bool isUpArrow;
  final Color color;

  GrowingArrowPainter({required this.isUpArrow, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final double width = size.width;
    final double height = size.height;
    final double centerX = width / 2;
    final double arrowWidth = width * 0.6;
    final double stemWidth = width * 0.3;

    // Create path for the arrow
    final path = Path();
    if (isUpArrow) {
      // Up arrow - grows upward from the bottom
      // Shadow
      final shadowPath = Path()
        ..moveTo(centerX - arrowWidth / 2, height * 0.5)
        ..lineTo(centerX, height * 0.2)
        ..lineTo(centerX + arrowWidth / 2, height * 0.5)
        ..lineTo(centerX + stemWidth / 2, height * 0.5)
        ..lineTo(centerX + stemWidth / 2, height * 0.8)
        ..lineTo(centerX - stemWidth / 2, height * 0.8)
        ..lineTo(centerX - stemWidth / 2, height * 0.5)
        ..close();
      canvas.drawPath(shadowPath, shadowPaint);

      // Arrow
      path.moveTo(centerX - arrowWidth / 2, height * 0.5);
      path.lineTo(centerX, height * 0.2);
      path.lineTo(centerX + arrowWidth / 2, height * 0.5);
      path.lineTo(centerX + stemWidth / 2, height * 0.5);
      path.lineTo(centerX + stemWidth / 2, height * 0.8);
      path.lineTo(centerX - stemWidth / 2, height * 0.8);
      path.lineTo(centerX - stemWidth / 2, height * 0.5);
      path.close();
    } else {
      // Down arrow - grows downward from the top
      // Shadow
      final shadowPath = Path()
        ..moveTo(centerX - arrowWidth / 2, height * 0.5)
        ..lineTo(centerX, height * 0.8)
        ..lineTo(centerX + arrowWidth / 2, height * 0.5)
        ..lineTo(centerX + stemWidth / 2, height * 0.5)
        ..lineTo(centerX + stemWidth / 2, height * 0.2)
        ..lineTo(centerX - stemWidth / 2, height * 0.2)
        ..lineTo(centerX - stemWidth / 2, height * 0.5)
        ..close();
      canvas.drawPath(shadowPath, shadowPaint);

      // Arrow
      path.moveTo(centerX - arrowWidth / 2, height * 0.5);
      path.lineTo(centerX, height * 0.8);
      path.lineTo(centerX + arrowWidth / 2, height * 0.5);
      path.lineTo(centerX + stemWidth / 2, height * 0.5);
      path.lineTo(centerX + stemWidth / 2, height * 0.2);
      path.lineTo(centerX - stemWidth / 2, height * 0.2);
      path.lineTo(centerX - stemWidth / 2, height * 0.5);
      path.close();
    }

    // Draw the arrow with 3D effect
    canvas.drawPath(path, paint);

    // Add highlight to create 3D effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final highlightPath = Path();
    if (isUpArrow) {
      highlightPath.moveTo(centerX - arrowWidth / 2, height * 0.5);
      highlightPath.lineTo(centerX, height * 0.2);
      highlightPath.lineTo(centerX + arrowWidth / 4, height * 0.35);
      highlightPath.close();
    } else {
      highlightPath.moveTo(centerX - arrowWidth / 2, height * 0.5);
      highlightPath.lineTo(centerX, height * 0.8);
      highlightPath.lineTo(centerX + arrowWidth / 4, height * 0.65);
      highlightPath.close();
    }
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant GrowingArrowPainter oldDelegate) {
    return oldDelegate.isUpArrow != isUpArrow || oldDelegate.color != color;
  }
}