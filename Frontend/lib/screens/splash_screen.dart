import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Fade-in and zoom-out animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.7, curve: Curves.easeInOut)
        )
    );

    _zoomAnimation = Tween<double>(begin: 0.5, end: 2.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1.0, curve: Curves.easeInOutBack)
        )
    );

    _controller.forward();

    // Navigate to login screen after animation
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _zoomAnimation,
            child: Image.asset(
              'assets/images/NEW_NAME_LOGO.png',
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.white)
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}