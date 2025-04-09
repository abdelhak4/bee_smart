import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'dart:math' as math;

class HexagonLogo extends StatelessWidget {
  final String size;

  const HexagonLogo({
    Key? key,
    this.size = 'md',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeValue;
    switch (size) {
      case 'sm':
        sizeValue = 40.0;
        break;
      case 'md':
        sizeValue = 80.0;
        break;
      case 'lg':
        sizeValue = 120.0;
        break;
      default:
        sizeValue = 80.0;
    }

    return SizedBox(
      width: sizeValue,
      height: sizeValue,
      child: CustomPaint(
        painter: HexagonPainter(),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;
    final double radius = math.min(width, height) / 2;
    final double centerX = width / 2;
    final double centerY = height / 2;

    final Path path = Path();

    // Create a hexagon path
    for (int i = 0; i < 6; i++) {
      final double angle = (i * 60 + 30) * math.pi / 180;
      final double x = centerX + radius * math.cos(angle);
      final double y = centerY + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // Draw a bee silhouette or a simpler representation
    final Paint beePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Body
    final double bodyWidth = radius * 0.6;
    final double bodyHeight = radius * 0.8;
    final Rect bodyRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: bodyWidth,
      height: bodyHeight,
    );
    canvas.drawOval(bodyRect, beePaint);

    // Stripes
    final Paint stripePaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final double stripeHeight = bodyHeight / 5;
    for (int i = 0; i < 3; i++) {
      final double top = centerY - bodyHeight / 2 + (i + 1) * stripeHeight;
      final Rect stripeRect = Rect.fromLTWH(
        centerX - bodyWidth / 2,
        top,
        bodyWidth,
        stripeHeight * 0.6,
      );
      canvas.drawRect(stripeRect, stripePaint);
    }

    // Wings
    final Paint wingPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final double wingRadius = radius * 0.3;
    canvas.drawCircle(
      Offset(centerX - bodyWidth / 4, centerY - bodyHeight / 4),
      wingRadius,
      wingPaint,
    );
    canvas.drawCircle(
      Offset(centerX + bodyWidth / 4, centerY - bodyHeight / 4),
      wingRadius,
      wingPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}