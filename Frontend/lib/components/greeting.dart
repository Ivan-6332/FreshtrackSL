import 'package:flutter/material.dart';
import '../config/app_localizations.dart';

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) {
    // We're ignoring the goodMorning localization and using "Hi" directly
    // but still using the same structure

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Colors.green.shade600,
            Colors.teal.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Row(
          children: [
            Text(
              "Hi",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.2,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..color = Colors.green.shade500,
                shadows: [
                  Shadow(
                    offset: const Offset(2, 2),
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade400,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}