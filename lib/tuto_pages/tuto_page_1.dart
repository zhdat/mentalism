import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TutoPage1 extends StatefulWidget {
  const TutoPage1({Key? key}) : super(key: key);

  @override
  _TutoPage1State createState() => _TutoPage1State();
}

class _TutoPage1State extends State<TutoPage1> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 117, 235),
      body: Center(
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildWelcomeText(),
        const SizedBox(height: 20.0),
        buildDescriptionText(),
        buildLottieAnimation(),
      ],
    );
  }

  Widget buildWelcomeText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "Bienvenue sur cette application de mentalisme !",
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
        "Le but de cette application est de remplacer le chiffre des centièmes de secondes par un chiffre choisi par le prestiditateur.",
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
      'https://lottie.host/9de1b987-4941-41f1-b302-89c3d57aa053/NTKHBdsG3M.json',
      height: 300.0,
      width: 300.0,
    );
  }
}
