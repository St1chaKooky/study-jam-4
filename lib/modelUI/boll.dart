import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimationWidget extends StatefulWidget {
  String magicResponse;
  bool isLoading;
  bool isError;
  final VoidCallback onPhoneShakeCallback;
  final Future<void> Function() fetchMagicResponse;

  AnimationWidget({
    required this.magicResponse,
    required this.isLoading,
    required this.isError,
    required this.onPhoneShakeCallback,
    required this.fetchMagicResponse,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat(reverse: true);
  late final Animation<Offset> _animation = Tween(
    begin: Offset.zero,
    end: const Offset(0, 0.08),
  ).animate(_controller);

  void onShakeDetected() {
    widget.onPhoneShakeCallback();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.magicResponse =
                ''; // Обращение к переданной переменной через widget
            widget.isLoading =
                true; // Обращение к переданной переменной через widget
          });

          widget.fetchMagicResponse().then((_) {
            setState(() {
              widget.isLoading =
                  false; // Обращение к переданной переменной через widget
            });
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 319,
              height: 319,
              // color: Colors.green,
              child: Image.asset('images/planet.png'),
            ),
            if ((widget.magicResponse.isNotEmpty) || widget.isLoading)
              Image.asset(
                'images/dark.png',
                width: 319,
                height: 319,
              ),
            if (widget.isError)
              Image.asset(
                'images/planetRed.png',
                width: 319,
                height: 319,
              ),
            Text(
              widget.magicResponse,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
