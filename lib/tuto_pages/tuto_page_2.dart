import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TutoPage2 extends StatefulWidget {
  const TutoPage2({Key? key}) : super(key: key);

  @override
  _TutoPage2State createState() => _TutoPage2State();
}

class _TutoPage2State extends State<TutoPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 143, 117, 235),
      body: Center(
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildMethodText(),
        const SizedBox(height: 20.0),
        buildDescriptionText(),
        buildLottieAnimation(),
      ],
    );
  }

  Widget buildMethodText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "Pour cela il y a 2 méthodes",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildDescriptionText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "Tu peux ajouter des nombres manuellement dans les paramètres avant le tour. Tu peux aussi utiliser la caméra arrière de ton téléphone pour la reconnaissance de texte.",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildLottieAnimation() {
    return Lottie.network(
      'https://lottie.host/49ff4810-9a59-4c8a-9230-809751950323/8ELcu7XGHg.json',
      height: 300.0,
      width: 300.0,
    );
  }
}
