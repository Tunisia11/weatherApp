
// Storm Animation
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/ui/widgets/animations/rainAimation.dart';

class StormAnimation extends StatefulWidget {
  const StormAnimation({Key? key}) : super(key: key);

  @override
  State<StormAnimation> createState() => _StormAnimationState();
}

class _StormAnimationState extends State<StormAnimation> with TickerProviderStateMixin {
  late final AnimationController _rainController;
  late final AnimationController _lightningController;
  late final Animation<double> _flashAnimation;
  final List<RainDrop> _rainDrops = [];
  final Random _random = Random();
  bool _showLightning = false;
  double _nextLightning = 0;
  static const int _numberOfDrops = 70;

  @override
  void initState() {
    super.initState();
    
    // Initialize rain animation controller
    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
    
    // Initialize lightning animation controller
    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _lightningController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Create random rain drops
    for (int i = 0; i < _numberOfDrops; i++) {
      _rainDrops.add(
        RainDrop(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          length: 10 + _random.nextDouble() * 25,
          speed: 0.3 + _random.nextDouble() * 0.7,
          thickness: 1 + _random.nextDouble() * 1.5,
          opacity: 0.3 + _random.nextDouble() * 0.7,
        ),
      );
    }
    
    // Schedule lightning animation
    _scheduleNextLightning();
  }

  void _scheduleNextLightning() {
    // Random delay between lightning flashes (2-6 seconds)
    _nextLightning = 2000 + _random.nextDouble() * 4000;
    Future.delayed(Duration(milliseconds: _nextLightning.toInt()), () {
      if (mounted) {
        _flashLightning();
      }
    });
  }

  void _flashLightning() {
    setState(() {
      _showLightning = true;
    });
    
    _lightningController.forward().then((_) {
      _lightningController.reverse().then((_) {
        // Occasionally do a second flash
        if (_random.nextDouble() > 0.6) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _lightningController.forward().then((_) {
                _lightningController.reverse().then((_) {
                  setState(() {
                    _showLightning = false;
                  });
                  _scheduleNextLightning();
                });
              });
            }
          });
        } else {
          setState(() {
            _showLightning = false;
          });
          _scheduleNextLightning();
        }
      });
    });
  }

  @override
  void dispose() {
    _rainController.dispose();
    _lightningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark sky background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1F2E),
                Color(0xFF232A3F),
              ],
            ),
          ),
        ),
        
        // Animated rain
        AnimatedBuilder(
          animation: _rainController,
          builder: (context, child) {
            return CustomPaint(
              painter: RainPainter(
                rainDrops: _rainDrops,
                animationValue: _rainController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Dark clouds
        CustomPaint(
          painter: StormCloudPainter(),
          size: Size.infinite,
        ),
        
        // Lightning flash
        if (_showLightning)
          AnimatedBuilder(
            animation: _flashAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withOpacity(_flashAnimation.value * 0.3),
              );
            },
          ),
        
        // Lightning bolt
        if (_showLightning)
          CustomPaint(
            painter: LightningPainter(
              startPoint: Offset(_random.nextDouble() * 0.8 + 0.1, 0),
            ),
            size: Size.infinite,
          ),
      ],
    );
  }
}

class StormCloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw dark storm clouds
    final paint = Paint()
      ..color = const Color(0xFF283044).withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    // Draw multiple cloud shapes
    _drawCloud(canvas, Offset(size.width * 0.3, size.height * 0.2), 40, paint);
    _drawCloud(canvas, Offset(size.width * 0.7, size.height * 0.15), 50, paint);
    _drawCloud(canvas, Offset(size.width * 0.5, size.height * 0.3), 45, paint);
    _drawCloud(canvas, Offset(size.width * 0.2, size.height * 0.4), 30, paint);
    _drawCloud(canvas, Offset(size.width * 0.8, size.height * 0.35), 35, paint);
  }

  void _drawCloud(Canvas canvas, Offset center, double baseRadius, Paint paint) {
    // Draw cloud shape using circles
    canvas.drawCircle(center, baseRadius, paint);
    
    // Top circles
    canvas.drawCircle(
      Offset(center.dx - baseRadius * 0.6, center.dy - baseRadius * 0.3),
      baseRadius * 0.7,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + baseRadius * 0.6, center.dy - baseRadius * 0.3),
      baseRadius * 0.7,
      paint,
    );
    
    // Bottom circles
    canvas.drawCircle(
      Offset(center.dx - baseRadius * 1.0, center.dy + baseRadius * 0.1),
      baseRadius * 0.6,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + baseRadius * 1.0, center.dy + baseRadius * 0.1),
      baseRadius * 0.6,
      paint,
    );
  }

  @override
  bool shouldRepaint(StormCloudPainter oldDelegate) => false;
}
class LightningPainter extends CustomPainter {
  final Offset startPoint;
  final Random _random = Random();

  LightningPainter({required this.startPoint});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.9)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(startPoint.dx * size.width, startPoint.dy * size.height);
    
    // Generate random zigzag lightning path
    double currentX = startPoint.dx * size.width;
    double currentY = startPoint.dy * size.height;
    
    // Number of zigzag segments
    final segments = 5 + _random.nextInt(4);
    final yStep = size.height / segments;
    
    for (int i = 0; i < segments; i++) {
      // Calculate next y position
      currentY += yStep;
      
      // Calculate next x position with random offset
      final xOffset = size.width * (_random.nextDouble() * 0.2 - 0.1);
      currentX += xOffset;
      
      // Keep within bounds
      if (currentX < 0) currentX = 0;
      if (currentX > size.width) currentX = size.width;
      
      // Draw line to next point
      path.lineTo(currentX, currentY);
      
      // Add branch with some probability
      if (_random.nextDouble() > 0.7 && i < segments - 1) {
        final branchPath = Path();
        branchPath.moveTo(currentX, currentY);
        
        // Create branching lightning
        double branchX = currentX;
        double branchY = currentY;
        
        final branchSegments = 2 + _random.nextInt(3);
        final branchYStep = yStep * 0.7;
        
        for (int j = 0; j < branchSegments; j++) {
          branchY += branchYStep;
          branchX += size.width * (_random.nextDouble() * 0.15 - 0.05);
          branchPath.lineTo(branchX, branchY);
        }
        
        // Draw branch with thinner stroke
        final branchPaint = Paint()
          ..color = Colors.yellowAccent.withOpacity(0.7)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
          
        canvas.drawPath(branchPath, branchPaint);
      }
    }
    
    // Draw main lightning path
    canvas.drawPath(path, paint);
    
    // Add glow effect
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(LightningPainter oldDelegate) => true;
}