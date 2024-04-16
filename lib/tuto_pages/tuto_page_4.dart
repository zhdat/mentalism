import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TutoPage4 extends StatefulWidget {
  const TutoPage4({Key? key}) : super(key: key);

  @override
  _TutoPage4State createState() => _TutoPage4State();
}

class _TutoPage4State extends State<TutoPage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 168, 102),
      body: Center(
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTitleText(),
        const SizedBox(height: 20.0),
        buildDescriptionText(),
        const SizedBox(height: 20.0),
        buildButtonsRow(),
        const SizedBox(height: 20.0),
        buildLottieAnimation(),
      ],
    );
  }

  Widget buildTitleText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "Changement de scénario",
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
        "Pour changer de scénario, appuie sur l'un des boutons en dessous pendant 2s. Par défaut, les chiffres des centièmes et des dixièmes sont modifiés. Tu peux aussi changer uniquement le chiffre des centièmes.",
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
        buildClearButtoniOS(),
        buildClearButtonAndroid(),
      ],
    );
  }

  Widget buildClearButtoniOS() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(34),
      ),
      child: const Text(
        'Effacer',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget buildClearButtonAndroid() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.lime[700],
        padding: const EdgeInsets.all(20),
      ),
      child: Icon(
        Icons.restart_alt,
        color: Colors.yellow[200],
      ),
    );
  }

  Widget buildLottieAnimation() {
    return Lottie.network(
      'https://lottie.host/dd11ecf0-05a3-4317-872d-c8d7beb65677/dsEStKMB9h.json',
      height: 200.0,
      width: 200.0,
    );
  }
}
