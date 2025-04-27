
// Sun Animation
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SunAnimation extends StatefulWidget {
  const SunAnimation({Key? key}) : super(key: key);

  @override
  State<SunAnimation> createState() => _SunAnimationState();
}

class _SunAnimationState extends State<SunAnimation> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _raysController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the sun
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Rotation animation for sun rays
    _raysController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _raysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient for sky
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4A7FBB),
                Color(0xFF2A3045),
              ],
            ),
          ),
        ),
        
        // Sun rays
        AnimatedBuilder(
          animation: _raysController,
          builder: (context, child) {
            return CustomPaint(
              painter: SunRaysPainter(
                animationValue: _raysController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Sun circle
        Positioned(
          top: 10,
          right: 20,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.yellow.shade200,
                        Colors.orange.shade400,
                      ],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SunRaysPainter extends CustomPainter {
  final double animationValue;

  SunRaysPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width - 55, 45);
    final radius = 100.0;
    final rayLength = 80.0;
    final rayCount = 12;
    
    // Draw rays
    for (int i = 0; i < rayCount; i++) {
      final angle = 2 * pi * i / rayCount + animationValue * 2 * pi;
      final startPoint = Offset(
        center.dx + radius * 0.5 * cos(angle),
        center.dy + radius * 0.5 * sin(angle),
      );
      final endPoint = Offset(
        center.dx + (radius + rayLength) * cos(angle),
        center.dy + (radius + rayLength) * sin(angle),
      );
      
      final paint = Paint()
        ..color = Colors.orange.withOpacity(0.3)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(SunRaysPainter oldDelegate) => true;
}
