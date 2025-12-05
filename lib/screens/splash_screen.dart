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
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Draw gear teeth around the circle
    final gearPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const teethCount = 12;
    for (int i = 0; i < teethCount; i++) {
      final angle = (i * 2 * math.pi) / teethCount;
      final x1 = center.dx + (radius + 15) * math.cos(angle);
      final y1 = center.dy + (radius + 15) * math.sin(angle);
      final x2 = center.dx + (radius + 25) * math.cos(angle);
      final y2 = center.dy + (radius + 25) * math.sin(angle);
      
      canvas.drawCircle(Offset(x2, y2), 4, gearPaint);
    }

    // Draw main circle
    canvas.drawCircle(center, radius, strokePaint);

    // Draw arrows pointing up
    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Main arrow
    final arrowPath = Path();
    arrowPath.moveTo(center.dx, center.dy - 30);
    arrowPath.lineTo(center.dx - 15, center.dy - 15);
    arrowPath.lineTo(center.dx - 8, center.dy - 15);
    arrowPath.lineTo(center.dx - 8, center.dy + 10);
    arrowPath.lineTo(center.dx + 8, center.dy + 10);
    arrowPath.lineTo(center.dx + 8, center.dy - 15);
    arrowPath.lineTo(center.dx + 15, center.dy - 15);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);

    // Side arrow
    final sideArrowPath = Path();
    sideArrowPath.moveTo(center.dx + 20, center.dy - 10);
    sideArrowPath.lineTo(center.dx + 35, center.dy - 25);
    sideArrowPath.lineTo(center.dx + 42, center.dy - 18);
    sideArrowPath.lineTo(center.dx + 27, center.dy - 3);
    sideArrowPath.close();
    canvas.drawPath(sideArrowPath, arrowPaint);

    // Draw curved lines
    final curvePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final curvePath = Path();
    curvePath.moveTo(center.dx - 30, center.dy + 30);
    curvePath.quadraticBezierTo(center.dx, center.dy + 20, center.dx + 30, center.dy + 30);
    canvas.drawPath(curvePath, curvePaint);

    final smallCurvePath = Path();
    smallCurvePath.moveTo(center.dx - 25, center.dy + 40);
    smallCurvePath.quadraticBezierTo(center.dx - 10, center.dy + 30, center.dx + 5, center.dy + 40);
    canvas.drawPath(smallCurvePath, curvePaint);

    // Draw small circles
    canvas.drawCircle(Offset(center.dx - 15, center.dy - 15), 3, paint);
    canvas.drawCircle(Offset(center.dx + 15, center.dy - 15), 3, paint);
    canvas.drawCircle(Offset(center.dx, center.dy + 20), 3, paint);

    // Draw text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'PERFORMANCE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + 50),
    );

    final subTextPainter = TextPainter(
      text: const TextSpan(
        text: 'OPTIMIZER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    subTextPainter.layout();
    subTextPainter.paint(
      canvas,
      Offset(center.dx - subTextPainter.width / 2, center.dy + 70),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}