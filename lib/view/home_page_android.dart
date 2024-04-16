import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mentalism/model/time_model.dart';
import 'package:provider/provider.dart';

class HomePageAndroid extends StatefulWidget {
  const HomePageAndroid({Key? key}) : super(key: key);

  @override
  State<HomePageAndroid> createState() => _HomePageAndroidState();
}

class _HomePageAndroidState extends State<HomePageAndroid> {
  int indexNumbers = 0;
  int indexPairNumbers = 0;
  int lengthPairNumbers = 0;
  int lengthNumbers = 0;

  List<String> numbers = [];
  List<String> pairNumbersList = [];

  bool isForcable = false;

  Future<void> scanImage(BuildContext context) async {
    final TextRecognizer textRecognizer = TextRecognizer();
    final myBox = Hive.box("Data");

    final timeModel = Provider.of<TimeModel>(context, listen: false);

    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      final cameraController = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      await cameraController.initialize();
      final pictureFile = await cameraController.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      isForcable = true;
      numbers = [];
      pairNumbersList = [];

      indexNumbers = 0;
      indexPairNumbers = 0;

      numbers = recognizedText.text
          .replaceAll(RegExp(r'[^0-9]'), '')
          .split('')
          .where((char) => char.isNotEmpty)
          .toList();

      // Mettre en pair les nombres
      for (int i = 0; i < numbers.length; i += 2) {
        if (i == 0 && numbers.length % 2 != 0) {
          pairNumbersList.add("0");
        }
        pairNumbersList.add(numbers[i] + numbers[i + 1]);
      }
      lengthNumbers = numbers.length;
      lengthPairNumbers = pairNumbersList.length;

      if (timeModel.isPairMode) {
        myBox.put(0, pairNumbersList[indexPairNumbers]);
      } else {
        myBox.put(0, numbers[indexNumbers]);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(numbers.isNotEmpty ? numbers.join('') : ''),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Une erreur s\'est produite lors de la numérisation du texte'),
        ),
      );
    } finally {
      textRecognizer.close();
    }
    updateUI();
  }

  void updateUI() {
    setState(() {});
  }

  bool _isButtonCircle = true;
  DateTime _pressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final myBox = Hive.box("Data");
    final hasNumber = myBox.get(0) != null;
    return Consumer<TimeModel>(
      builder: (context, value, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildImageScanButton(context, hasNumber),
            buildStopwatchDisplay(value),
            const SizedBox(height: 20),
            buildControlButtons(context, value, myBox),
          ],
        ),
      ),
    );
  }

Widget buildImageScanButton(BuildContext context, bool hasNumber) {
  return ElevatedButton(
    onPressed: () => scanImage(context),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
    ),
    child: Text(
      '. .',
      style: TextStyle(
        color: hasNumber ? Colors.white : Colors.brown,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget buildStopwatchDisplay(TimeModel value) {
  return Align(
    alignment: Alignment.center,
    child: Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 250,
        width: 250,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.brown,
                  width: 4,
                ),
              ),
            ),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 80,
                    child: Text(
                      value.digitSeconds,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    right: 100,
                    child: Text(
                      value.digitMiliseconds,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildControlButtons(BuildContext context, TimeModel value, Box myBox) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildResetButton(context, value),
      buildStartStopButton(context, value, myBox),
      buildLapButton(context, value),
    ],
  );
}

Widget buildResetButton(BuildContext context, TimeModel value) {
  return GestureDetector(
    onLongPressStart: (details) {
      _pressTime = DateTime.now();
    },
    onLongPressEnd: (details) {
      final duration = DateTime.now().difference(_pressTime);
      if (duration.inSeconds >= 1) {
        final timer = context.read<TimeModel>();
        timer.toggleMode();
      }
    },
    child: ElevatedButton(
      onPressed: () {
        final timer = context.read<TimeModel>();
        if (timer.started) {
          timer.lap();
        } else {
          timer.reset();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: context.watch<TimeModel>().isPairMode
            ? Colors.lime[900]
            : Colors.lime[700],
        padding: const EdgeInsets.all(20),
      ),
      child: Icon(
        Icons.restart_alt,
        color: Colors.white,
      ),
    ),
  );
}

Widget buildStartStopButton(BuildContext context, TimeModel value, Box myBox) {
  return GestureDetector(
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isButtonCircle ? 80 : 150,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          final timer = context.read<TimeModel>();

          if (timer.started) {
            timer.stop();
            if (isForcable) {
              if (timer.isPairMode) {
                if (indexPairNumbers >= lengthPairNumbers - 1) {
                  myBox.clear();
                  isForcable = false;
                } else {
                  indexPairNumbers++;
                  myBox.put(0, pairNumbersList[indexPairNumbers]);
                }
              } else {
                if (indexNumbers >= lengthNumbers - 1) {
                  myBox.clear();
                  isForcable = false;
                } else {
                  indexNumbers++;
                  myBox.put(0, numbers[indexNumbers]);
                }
              }
            } else {
              myBox.clear();
            }
          } else {
            timer.start();
          }

          setState(() {
            _isButtonCircle = !_isButtonCircle;
          });
        },
        style: ElevatedButton.styleFrom(
          shape: _isButtonCircle
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
          backgroundColor: Colors.red[200],
          padding: const EdgeInsets.all(20),
        ),
        child: Icon(
          value.started ? Icons.pause : Icons.play_arrow,
          color: const Color.fromARGB(255, 21, 3, 1),
        ),
      ),
    ),
  );
}

Widget buildLapButton(BuildContext context, TimeModel value) {
  return ElevatedButton(
    onPressed: () {
      final timer = context.read<TimeModel>();
      if (timer.started) {
        timer.lap();
      } else {
        timer.reset();
      }
    },
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      backgroundColor: value.started
          ? Colors.lime[900]
          : const Color.fromARGB(255, 21, 3, 1),
      padding: const EdgeInsets.all(20),
    ),
    child: Icon(
      Icons.timer_sharp,
      color: value.started ? Colors.white : const Color.fromARGB(255, 21, 3, 1),
    ),
  );
}

}
