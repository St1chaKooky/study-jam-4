import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import '../modelUI/shodow.dart';
import '../utils/colors.dart';
import 'package:shake/shake.dart';

class MagicBallScreen extends StatefulWidget {
  const MagicBallScreen({Key? key}) : super(key: key);

  @override
  State<MagicBallScreen> createState() => _MagicBallScreenState();
}

class _MagicBallScreenState extends State<MagicBallScreen> {
  bool _isLoading = false;
  bool _isError = false;
  String magicResponse = '';

  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();

    // Инициализация ShakeDetector внутри метода initState
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      fetchMagicResponse(); // Вызов функции fetchMagicResponse при тряске телефона
    });
  }

  @override
  void dispose() {
    detector?.stopListening(); // Остановка ShakeDetector при удалении виджета
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
          magicResponse = 'Произошла ошибка, пожалуйста, повторите попытку.';
        });
      }
    } catch (e) {
      // Обработка ошибки, если нет интернета или сервер не ответил
      setState(() {
        _isError = true;
        magicResponse =
            'Произошла ошибка, пожалуйста, проверьте интернет-соединение и повторите попытку.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColor, darkColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: Column(children: [
          Flexible(
            flex: 3,
            child: Container(),
          ),
          InkWell(
            onTap: () {
              setState(() {
                magicResponse = '';
                _isLoading = true;
              });

              fetchMagicResponse().then((_) {
                setState(() {
                  _isLoading = false;
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
                if ((magicResponse.isNotEmpty) || _isLoading)
                  Image.asset(
                    'images/dark.png',
                    width: 319,
                    height: 319,
                  ),
                if (_isError)
                  Image.asset(
                    'images/planetRed.png',
                    width: 319,
                    height: 319,
                  ),
                Text(
                  magicResponse,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          const OvalStack(),
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
        ]),
      ),
    );
  }
}

// class AnimationWidget extends StatefulWidget {
//   const AnimationWidget({super.key});

//   @override
//   State<AnimationWidget> createState() => _AnimationWidgetState();
// }

// class _AnimationWidgetState extends State<AnimationWidget>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller =
//       AnimationController(vsync: this, duration: const Duration(seconds: 3));
//   late Animation<Offset> _animation = Tween(
//     begin: Offset.zero,
//     end: Offset(0, 0.08),
//   ).animate(_controller);

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _animation,
//       child: ,
//     );
//   }
// }
