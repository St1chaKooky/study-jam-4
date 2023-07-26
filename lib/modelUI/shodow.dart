import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OvalStack extends StatelessWidget {
  bool isDark;
  bool isError;
  OvalStack({super.key, required this.isError, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return isDark
        ? Stack(
            alignment: Alignment.center,
            children: [
              isError
                  ? CustomPaint(
                      size: const Size(250, 46),
                      painter: OvalPainter(
                        gradient: const RadialGradient(
                          center: Alignment.center,
                          radius: 2,
                          colors: [
                            Color.fromRGBO(114, 17, 17, 1),
                            Color.fromRGBO(80, 10, 71, 0.992),
                          ],
                        ),
                      ),
                    )
                  : CustomPaint(
                      size: const Size(250, 46),
                      painter: OvalPainter(
                        gradient: const RadialGradient(
                          center: Alignment.center,
                          radius: 2,
                          colors: [
                            Color.fromRGBO(70, 100, 134, 1),
                            Color.fromRGBO(23, 4, 34, 1),
                          ],
                        ),
                      ),
                    ),
              isError
                  ? CustomPaint(
                      size: const Size(130, 22),
                      painter: OvalPainter(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 139, 27, 27),
                            Color.fromARGB(255, 230, 27, 27),
                          ],
                        ),
                      ),
                    )
                  : CustomPaint(
                      size: const Size(130, 22),
                      painter: OvalPainter(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 27, 104, 139),
                            Color.fromARGB(255, 17, 116, 230),
                          ],
                        ),
                      ),
                    )
            ],
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              isError
                  ? CustomPaint(
                      size: const Size(250, 46),
                      painter: OvalPainter(
                        gradient: const RadialGradient(
                          center: Alignment.center,
                          radius: 2,
                          colors: [
                            Color.fromRGBO(114, 17, 17, 1),
                            Color.fromRGBO(80, 10, 71, 0.992),
                          ],
                        ),
                      ),
                    )
                  : CustomPaint(
                      size: const Size(250, 46),
                      painter: OvalPainter(
                        gradient: const RadialGradient(
                          center: Alignment.center,
                          radius: 2,
                          colors: [
                            Color.fromRGBO(156, 182, 212, 1),
                            Color.fromRGBO(204, 217, 255, 1),
                          ],
                        ),
                      ),
                    ),
              isError
                  ? CustomPaint(
                      size: const Size(130, 22),
                      painter: OvalPainter(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 139, 27, 27),
                            Color.fromARGB(255, 230, 27, 27),
                          ],
                        ),
                      ),
                    )
                  : CustomPaint(
                      size: const Size(130, 22),
                      painter: OvalPainter(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(156, 182, 212, 1),
                            Color.fromRGBO(204, 217, 255, 1),
                          ],
                        ),
                      ),
                    )
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
