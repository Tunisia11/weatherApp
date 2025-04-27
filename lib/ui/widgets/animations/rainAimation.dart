// Rain Animation
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RainAnimation extends StatefulWidget {
  const RainAnimation({Key? key}) : super(key: key);

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<RainDrop> _rainDrops = [];
  static const int _numberOfDrops = 60;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    
    // Create random rain drops
    final random = Random();
    for (int i = 0; i < _numberOfDrops; i++) {
      _rainDrops.add(
        RainDrop(
          x: random.nextDouble(),
          y: random.nextDouble(),
          length: 10 + random.nextDouble() * 20,
          speed: 0.2 + random.nextDouble() * 0.8,
          thickness: 1 + random.nextDouble() * 1.5,
          opacity: 0.3 + random.nextDouble() * 0.7,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RainPainter(
            rainDrops: _rainDrops,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class RainDrop {
  double x; // horizontal position (0-1)
  double y; // vertical position (0-1)
  double length; // length of the drop
  double speed; // speed factor (0-1)
  double thickness; // thickness of the drop
  double opacity; // opacity of the drop (0-1)

  RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.thickness,
    required this.opacity,
  });
}

class RainPainter extends CustomPainter {
  final List<RainDrop> rainDrops;
  final double animationValue;

  RainPainter({
    required this.rainDrops,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final drop in rainDrops) {
      // Calculate current position based on animation value and speed
      double currentY = (drop.y + animationValue * drop.speed) % 1.0;
      
      // Create rain drop as a line
      final paint = Paint()
        ..color = Colors.white.withOpacity(drop.opacity)
        ..strokeWidth = drop.thickness
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(
        Offset(drop.x * size.width, currentY * size.height),
        Offset(drop.x * size.width, (currentY * size.height) + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RainPainter oldDelegate) => true;
}
