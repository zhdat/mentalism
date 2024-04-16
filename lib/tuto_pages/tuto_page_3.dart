import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TutoPage3 extends StatefulWidget {
  const TutoPage3({Key? key}) : super(key: key);

  @override
  _TutoPage3State createState() => _TutoPage3State();
}

class _TutoPage3State extends State<TutoPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 155, 231, 136),
      body: Center(
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildScanTitle(),
        const SizedBox(height: 20.0),
        buildScanDescription(),
        buildButtonsRow(),
        const SizedBox(height: 10.0),
        buildLottieAnimation(),
        const SizedBox(height: 60.0),
      ],
    );
  }

  Widget buildScanTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "Scan de chiffres",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildScanDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "Pour scanner des chiffres, place ta caméra au-dessus de chiffres (cartes à jouer, billets...) et appuie sur le bouton ci-dessous. Celui-ci est situé en dessous du chronomètre pour la version IOS et au dessus du chronomètre pour la version Android.",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildBlackButton(),
        buildBrownButton(),
      ],
    );
  }

  Widget buildBlackButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
      child: const Text(
        '. .',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildBrownButton() {
    return ElevatedButton(
      onPressed: () => {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 21, 3, 1),
        shape: const CircleBorder(),
      ),
      child: const Text(
        '. .',
        style: TextStyle(
          color: Colors.brown,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildLottieAnimation() {
    return Lottie.network(
      'https://lottie.host/f19fc6d5-0a28-4e6b-b7ab-a0d443202860/anvyTvqkhq.json',
      height: 200.0,
      width: 200.0,
    );
  }

}
