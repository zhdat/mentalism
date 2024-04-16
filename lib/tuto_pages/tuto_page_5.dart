import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TutoPage5 extends StatefulWidget {
  const TutoPage5({Key? key}) : super(key: key);

  @override
  _TutoPage5State createState() => _TutoPage5State();
}

class _TutoPage5State extends State<TutoPage5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 117, 127),
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
        buildLottieAnimation(),
      ],
    );
  }

  Widget buildTitleText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "Dernière étape",
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
        "Maintenant, tu es prêt à impressionner tes amis avec tes tours de mentalisme ! Amuse-toi bien !",
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
      'https://lottie.host/809cf05f-42f7-4689-a250-d004d047efdd/5z0aJLNtQm.json',
      height: 300.0,
      width: 300.0,
    );
  }
}
