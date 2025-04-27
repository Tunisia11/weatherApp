
// Snow Animation
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SnowAnimation extends StatefulWidget {
  const SnowAnimation({Key? key}) : super(key: key);

  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Snowflake> _snowflakes = [];
  static const int _numberOfSnowflakes = 60;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // Create random snowflakes
    final random = Random();
    for (int i = 0; i < _numberOfSnowflakes; i++) {
      _snowflakes.add(
        Snowflake(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: 1 + random.nextDouble() * 4,
          speed: 0.05 + random.nextDouble() * 0.15,
          swayFactor: random.nextDouble() * 0.1,
          swayFrequency: 1 + random.nextDouble() * 3,
          opacity: 0.4 + random.nextDouble() * 0.6,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient for winter sky
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF3D4761),
                Color(0xFF2C3548),
              ],
            ),
          ),
        ),
        
        // Animated snowflakes
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: SnowPainter(
                snowflakes: _snowflakes,
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ],
    );
  }
}

class Snowflake {
  double x; // horizontal position (0-1)
  double y; // vertical position (0-1)
  double size; // size of the snowflake
  double speed; // falling speed
  double swayFactor; // how much it sways side to side
  double swayFrequency; // frequency of the sway
  double opacity; // opacity (0-1)

  Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.swayFactor,
    required this.swayFrequency,
    required this.opacity,
  });
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final double animationValue;

  SnowPainter({
    required this.snowflakes,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final flake in snowflakes) {
      // Calculate current position based on animation value and speed
      double currentY = (flake.y + animationValue * flake.speed) % 1.0;
      
      // Calculate horizontal sway
      double sway = sin(animationValue * 2 * pi * flake.swayFrequency) * flake.swayFactor;
      double currentX = (flake.x + sway) % 1.0;
      if (currentX < 0) currentX += 1.0;
      
      // Draw snowflake
      final paint = Paint()
        ..color = Colors.white.withOpacity(flake.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height),
        flake.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => true;
}
