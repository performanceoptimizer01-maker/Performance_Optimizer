import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create icon
  final iconWidget = Container(
    width: 512,
    height: 512,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1a1a1a),
          Color(0xFF2d2d2d),
        ],
      ),
      borderRadius: BorderRadius.circular(80),
    ),
    child: CustomPaint(
      painter: IconLogoPainter(),
      size: Size(512, 512),
    ),
  );

  // Convert to image
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  final painter = IconLogoPainter();
  painter.paint(canvas, Size(512, 512));
  
  final picture = recorder.endRecording();
  final img = await picture.toImage(512, 512);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();
  
  // Save icon
  final file = File('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png');
  await file.writeAsBytes(pngBytes);
  
  print('Icon created successfully!');
}

class IconLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final center = Offset(size.width / 2, size.height / 2);
    final gearRadius = size.width * 0.2;

    // Draw gear outer ring with teeth
    final gearPath = Path();
    const teethCount = 12;
    const toothHeight = 16;
    
    for (int i = 0; i < teethCount; i++) {
      final angle1 = (i * 2 * 3.14159) / teethCount;
      final angle2 = ((i + 0.3) * 2 * 3.14159) / teethCount;
      final angle3 = ((i + 0.7) * 2 * 3.14159) / teethCount;
      final angle4 = ((i + 1) * 2 * 3.14159) / teethCount;
      
      // Inner circle points
      final x1 = center.dx + gearRadius * cos(angle1);
      final y1 = center.dy + gearRadius * sin(angle1);
      final x2 = center.dx + gearRadius * cos(angle2);
      final y2 = center.dy + gearRadius * sin(angle2);
      
      // Outer tooth points
      final x3 = center.dx + (gearRadius + toothHeight) * cos(angle2);
      final y3 = center.dy + (gearRadius + toothHeight) * sin(angle2);
      final x4 = center.dx + (gearRadius + toothHeight) * cos(angle3);
      final y4 = center.dy + (gearRadius + toothHeight) * sin(angle3);
      
      // Back to inner circle
      final x5 = center.dx + gearRadius * cos(angle3);
      final y5 = center.dy + gearRadius * sin(angle3);
      final x6 = center.dx + gearRadius * cos(angle4);
      final y6 = center.dy + gearRadius * sin(angle4);
      
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
    canvas.drawCircle(center, gearRadius - 20, strokePaint);

    // Draw main upward arrow
    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final mainArrowPath = Path();
    mainArrowPath.moveTo(center.dx, center.dy - 40);
    mainArrowPath.lineTo(center.dx - 20, center.dy - 15);
    mainArrowPath.lineTo(center.dx - 10, center.dy - 15);
    mainArrowPath.lineTo(center.dx - 10, center.dy + 10);
    mainArrowPath.lineTo(center.dx + 10, center.dy + 10);
    mainArrowPath.lineTo(center.dx + 10, center.dy - 15);
    mainArrowPath.lineTo(center.dx + 20, center.dy - 15);
    mainArrowPath.close();
    canvas.drawPath(mainArrowPath, arrowPaint);

    // Draw flowing curves
    final curvePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final flowPath1 = Path();
    flowPath1.moveTo(center.dx - 60, center.dy + 30);
    flowPath1.quadraticBezierTo(center.dx - 20, center.dy + 50, center.dx + 30, center.dy + 40);
    flowPath1.quadraticBezierTo(center.dx + 60, center.dy + 30, center.dx + 80, center.dy + 50);
    canvas.drawPath(flowPath1, curvePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  
  double cos(double angle) => math.cos(angle);
  double sin(double angle) => math.sin(angle);
}

import 'dart:math' as math;