import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();

    // Navigate to home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        painter: LogoPainter(),
                        size: const Size(200, 200),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Loading indicator
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Loading text
                    const Text(
                      'Carregando...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final center = Offset(size.width / 2, size.height / 2 - 20);
    final gearRadius = size.width * 0.25;

    // Draw gear outer ring with teeth
    final gearPath = Path();
    const teethCount = 12;
    const toothHeight = 8;
    
    for (int i = 0; i < teethCount; i++) {
      final angle1 = (i * 2 * math.pi) / teethCount;
      final angle2 = ((i + 0.3) * 2 * math.pi) / teethCount;
      final angle3 = ((i + 0.7) * 2 * math.pi) / teethCount;
      final angle4 = ((i + 1) * 2 * math.pi) / teethCount;
      
      // Inner circle points
      final x1 = center.dx + gearRadius * math.cos(angle1);
      final y1 = center.dy + gearRadius * math.sin(angle1);
      final x2 = center.dx + gearRadius * math.cos(angle2);
      final y2 = center.dy + gearRadius * math.sin(angle2);
      
      // Outer tooth points
      final x3 = center.dx + (gearRadius + toothHeight) * math.cos(angle2);
      final y3 = center.dy + (gearRadius + toothHeight) * math.sin(angle2);
      final x4 = center.dx + (gearRadius + toothHeight) * math.cos(angle3);
      final y4 = center.dy + (gearRadius + toothHeight) * math.sin(angle3);
      
      // Back to inner circle
      final x5 = center.dx + gearRadius * math.cos(angle3);
      final y5 = center.dy + gearRadius * math.sin(angle3);
      final x6 = center.dx + gearRadius * math.cos(angle4);
      final y6 = center.dy + gearRadius * math.sin(angle4);
      
      if (i == 0) {
        gearPath.moveTo(x1, y1);
      }
      gearPath.lineTo(x2, y2);
      gearPath.lineTo(x3, y3);
      gearPath.lineTo(x4, y4);
      gearPath.lineTo(x5, y5);
      gearPath.lineTo(x6, y6);
    }
    gearPath.close();
    canvas.drawPath(gearPath, paint);

    // Draw inner circle
    canvas.drawCircle(center, gearRadius - 15, strokePaint);

    // Draw small circles around the inner circle
    const smallCircleCount = 8;
    for (int i = 0; i < smallCircleCount; i++) {
      final angle = (i * 2 * math.pi) / smallCircleCount;
      final x = center.dx + (gearRadius - 15) * math.cos(angle);
      final y = center.dy + (gearRadius - 15) * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }

    // Draw main upward arrows
    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Large central arrow pointing up
    final mainArrowPath = Path();
    mainArrowPath.moveTo(center.dx, center.dy - 25);
    mainArrowPath.lineTo(center.dx - 12, center.dy - 10);
    mainArrowPath.lineTo(center.dx - 6, center.dy - 10);
    mainArrowPath.lineTo(center.dx - 6, center.dy + 5);
    mainArrowPath.lineTo(center.dx + 6, center.dy + 5);
    mainArrowPath.lineTo(center.dx + 6, center.dy - 10);
    mainArrowPath.lineTo(center.dx + 12, center.dy - 10);
    mainArrowPath.close();
    canvas.drawPath(mainArrowPath, arrowPaint);

    // Second arrow pointing up-right
    final secondArrowPath = Path();
    secondArrowPath.moveTo(center.dx + 15, center.dy - 15);
    secondArrowPath.lineTo(center.dx + 8, center.dy - 8);
    secondArrowPath.lineTo(center.dx + 12, center.dy - 4);
    secondArrowPath.lineTo(center.dx + 25, center.dy - 17);
    secondArrowPath.lineTo(center.dx + 21, center.dy - 21);
    secondArrowPath.close();
    canvas.drawPath(secondArrowPath, arrowPaint);

    // Draw curved flowing lines at the bottom
    final curvePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Main flowing curve
    final flowPath1 = Path();
    flowPath1.moveTo(center.dx - 35, center.dy + 20);
    flowPath1.quadraticBezierTo(center.dx - 10, center.dy + 35, center.dx + 20, center.dy + 25);
    flowPath1.quadraticBezierTo(center.dx + 40, center.dy + 15, center.dx + 50, center.dy + 30);
    canvas.drawPath(flowPath1, curvePaint);

    // Secondary flowing curve
    final flowPath2 = Path();
    flowPath2.moveTo(center.dx - 25, center.dy + 30);
    flowPath2.quadraticBezierTo(center.dx, center.dy + 40, center.dx + 25, center.dy + 35);
    canvas.drawPath(flowPath2, curvePaint);

    // Third flowing curve
    final flowPath3 = Path();
    flowPath3.moveTo(center.dx - 15, center.dy + 40);
    flowPath3.quadraticBezierTo(center.dx + 5, center.dy + 45, center.dx + 15, center.dy + 42);
    canvas.drawPath(flowPath3, curvePaint);

    // Draw text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'PERFORMANCE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + 65),
    );

    final subTextPainter = TextPainter(
      text: const TextSpan(
        text: 'OPTIMIZER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 3.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    subTextPainter.layout();
    subTextPainter.paint(
      canvas,
      Offset(center.dx - subTextPainter.width / 2, center.dy + 85),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}