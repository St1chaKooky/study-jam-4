import 'package:flutter/material.dart';

class OvalStack extends StatelessWidget {
  const OvalStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(250, 46),
          painter: OvalPainter(
            gradient: const RadialGradient(
              center: Alignment.center,
              radius: 2,
              colors: [
                Color.fromRGBO(70, 100, 134, 1),
                Color.fromRGBO(35, 11, 49, 1),
              ],
            ),
          ),
        ),
        CustomPaint(
          size: const Size(130, 22),
          painter: OvalPainter(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 27, 104, 139),
                Color.fromARGB(255, 27, 183, 230),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OvalPainter extends CustomPainter {
  final Gradient? gradient;

  OvalPainter({this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (gradient != null) {
      final paint = Paint()
        ..shader = gradient!.createShader(rect)
        ..maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 4); // Добавляем размытие
      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
