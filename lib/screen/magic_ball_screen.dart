import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import '../modelUI/boll.dart';
import '../modelUI/shodow.dart';
import '../utils/colors.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(MagicBallApp());
}

class MagicBallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MagicBallScreen(),
    );
  }
}

class MagicBallScreen extends StatefulWidget {
  const MagicBallScreen({Key? key}) : super(key: key);

  @override
  State<MagicBallScreen> createState() => _MagicBallScreenState();
}

class _MagicBallScreenState extends State<MagicBallScreen> {
  bool _isDarkTheme = false;
  bool _isLoading = false;
  bool _isError = false;
  String magicResponse = '';

  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        magicResponse = '';
        _isLoading = true;
      });
      fetchMagicResponse();
    });
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  Future<void> fetchMagicResponse() async {
    const baseUrl = 'https://eightballapi.com/api';

    try {
      final response = await http.get(Uri.parse('$baseUrl'));

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        String englishResponse = decodedResponse['reading'];

        final translator = GoogleTranslator();
        Translation translation =
            await translator.translate(englishResponse, from: 'en', to: 'ru');
        String russianResponse = translation.text;

        setState(() {
          magicResponse = russianResponse;
          _isError = false;
        });
      } else {
        setState(() {
          _isError = true;
          magicResponse = 'Ошибка';
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        magicResponse = 'Проверьте интернет-соединение';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isDarkTheme
                  ? [blueColor, Colors.black] // Градиент для темной темы
                  : [colorWhite, coloreLight], // Градиент для светлой темы
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isDarkTheme = !_isDarkTheme;
                      });
                    },
                    icon: Icon(
                      _isDarkTheme ? Icons.wb_sunny : Icons.nights_stay,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Flexible(
                flex: 3,
                child: Container(),
              ),
              AnimationWidget(
                magicResponse: magicResponse,
                isLoading: _isLoading,
                isError: _isError,
                onPhoneShakeCallback: fetchMagicResponse,
                fetchMagicResponse: fetchMagicResponse,
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              OvalStack(isError: _isError),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              const Column(
                children: [
                  Text(
                    'Нажмите на шар',
                    style: TextStyle(color: greyColor, fontSize: 16),
                  ),
                  Text(
                    'или потрясите телефон',
                    style: TextStyle(color: greyColor, fontSize: 16),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      _controller.duration = const Duration(
          seconds: 1); // Уменьшаем длительность анимации в режиме загрузки
    } else {
      _controller.duration = const Duration(
          seconds: 3); // Восстанавливаем обычную длительность анимации
    }

    return SlideTransition(
      position: _animation,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.magicResponse = '';
            widget.isLoading = true;
          });

          widget.fetchMagicResponse().then((_) {
            setState(() {
              widget.isLoading = false;
            });
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 319,
              height: 319,
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
