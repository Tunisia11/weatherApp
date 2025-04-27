import 'dart:math';

import 'package:flutter/material.dart';

class CloudAnimation extends StatefulWidget {
  const CloudAnimation({Key? key}) : super(key: key);

  @override
  State<CloudAnimation> createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<CloudAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Cloud> _clouds = [];
  static const int _numberOfClouds = 13; // Increased number of clouds

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller with faster animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    )..repeat();
    
    // Create random clouds with better distribution
    final random = Random();
    for (int i = 0; i < _numberOfClouds; i++) {
      _clouds.add(
        Cloud(
          x: random.nextDouble() * 2.0 - 0.5, // Start position (-0.5 to 1.5)
          y: 0.05 + random.nextDouble() * 0.8, // Height position (0.05 to 0.85)
          speed: 0.6 + random.nextDouble() * 1.0, // Much faster speed (0.6 to 1.6)
          scale: 0.2 + random.nextDouble() * 0.8, // Size of the cloud (more variation)
          opacity: 0.4 + random.nextDouble() * 0.6, // Opacity (more variation)
        ),
      );
    }
    
    // Add a few extra large background clouds that move more slowly
    for (int i = 0; i < 3; i++) {
      _clouds.add(
        Cloud(
          x: random.nextDouble() * 2.0 - 0.5,
          y: 0.1 + random.nextDouble() * 0.5,
          speed: 0.2 + random.nextDouble() * 0.3, // Slower speed for depth effect
          scale: 1.0 + random.nextDouble() * 0.5, // Larger size
          opacity: 0.2 + random.nextDouble() * 0.3, // Lower opacity for background effect
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
        // Background gradient for sky (enhanced colors)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF6B90C0),  // Lighter blue at top
                Color(0xFF4A6E9E),
                Color(0xFF2D3240),
              ],
            ),
          ),
        ),
        
        // Animated clouds
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: CloudPainter(
                clouds: _clouds,
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

class Cloud {
  double x; // horizontal position (starting point)
  double y; // vertical position (0-1)
  double speed; // movement speed
  double scale; // size scale factor
  double opacity; // opacity (0-1)

  Cloud({
    required this.x,
    required this.y,
    required this.speed,
    required this.scale,
    required this.opacity,
  });
}

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;
  final double animationValue;

  CloudPainter({
    required this.clouds,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final cloud in clouds) {
      // Calculate current x position with fixed movement calculation
      // The key fix: multiplying by a larger factor to ensure visible movement
      double currentX = cloud.x - (animationValue * cloud.speed);
      
      // Wrap around the screen when off-screen left
      if (currentX < -0.5) {
        currentX = 1.5;
      }
      
      // Draw cloud at the calculated position
      _drawCloud(
        canvas,
        Offset(currentX * size.width, cloud.y * size.height),
        cloud.scale,
        cloud.opacity,
        size,
      );
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double scale, double opacity, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0); // Added blur for softer clouds
    
    // Enhanced cloud shape with more circles for natural appearance
    final baseRadius = 25.0 * scale;
    
    // Middle circle
    canvas.drawCircle(center, baseRadius, paint);
    
    // Top circles
    canvas.drawCircle(
      Offset(center.dx - baseRadius * 0.6, center.dy - baseRadius * 0.3),
      baseRadius * 0.8,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + baseRadius * 0.6, center.dy - baseRadius * 0.3),
      baseRadius * 0.8,
      paint,
    );
    
    // Additional top circle
    canvas.drawCircle(
      Offset(center.dx, center.dy - baseRadius * 0.4),
      baseRadius * 0.7,
      paint,
    );
    
    // Bottom and side circles
    canvas.drawCircle(
      Offset(center.dx - baseRadius * 1.0, center.dy + baseRadius * 0.1),
      baseRadius * 0.7,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + baseRadius * 1.0, center.dy + baseRadius * 0.1),
      baseRadius * 0.7,
      paint,
    );
    
    // Additional bottom circle
    canvas.drawCircle(
      Offset(center.dx + baseRadius * 0.3, center.dy + baseRadius * 0.3),
      baseRadius * 0.6,
      paint,
    );
  }

  @override
  bool shouldRepaint(CloudPainter oldDelegate) => 
    oldDelegate.animationValue != animationValue;
}