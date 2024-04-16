import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mentalism/model/time_model.dart';
import 'package:provider/provider.dart';

class HomePageIos extends StatefulWidget {
  const HomePageIos({Key? key}) : super(key: key);

  @override
  State<HomePageIos> createState() => _HomePageIosState();
}

class _HomePageIosState extends State<HomePageIos> with WidgetsBindingObserver {
  DateTime _pressTime = DateTime.now();
  int indexNumbers = 0;
  int indexPairNumbers = 0;
  int lengthNumbers = 0;
  int lengthPairNumbers = 0;

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

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeModel>(
      builder: (context, value, child) {
        return Center(
          child: buildUI(context, value),
        );
      },
    );
  }

  Widget buildUI(BuildContext context, TimeModel value) {
    final myBox = Hive.box("Data");
    final hasNumber = myBox.get(0) != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildTimerDisplay(value),
        buildButtons(context, value, myBox, hasNumber),
        buildLapsList(value),
      ],
    );
  }

  Widget buildTimerDisplay(TimeModel value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: 120,
        width: 350,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${value.digitMinutes}:${value.digitSeconds}:${value.digitMiliseconds}',
              style: const TextStyle(color: Colors.white, fontSize: 75),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtons(
      BuildContext context, TimeModel value, Box myBox, bool hasNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTourButton(context, value),
        buildClearButton(context, value, myBox, hasNumber),
        buildStartStopButton(context, value, myBox),
      ],
    );
  }

  Widget buildTourButton(BuildContext context, TimeModel value) {
    return value.started
        ? ElevatedButton(
            onPressed: () {
              final timer = context.read<TimeModel>();
              if (value.started) {
                timer.lap();
              }
            }, // Texte pour le bouton "Tour" avec le style
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[850],
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(34),
            ),
            child: const Text('Tour',
                style: TextStyle(color: Colors.white, fontSize: 14)),
          )
        : GestureDetector(
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
                if (!value.started) {
                  timer.reset();
                }
              }, // Texte pour le bouton "Effacer" avec le style
              style: ElevatedButton.styleFrom(
                backgroundColor: context.watch<TimeModel>().isPairMode
                    ? Colors.grey[850]
                    : Colors.grey[900],
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(34),
              ),
              child: const Text('Effacer',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          );
  }

  Widget buildStartStopButton(
      BuildContext context, TimeModel value, Box myBox) {
    return value.started
        ? ElevatedButton(
            onPressed: () {
              final timer = context.read<TimeModel>();
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
                  } else {
                    indexNumbers++;
                    myBox.put(0, numbers[indexNumbers]);
                  }
                }
              } else {
                myBox.clear();
              }
            }, // Texte pour le bouton "Arrêter" avec le style
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[900],
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(34),
            ),
            child: const Text('Arrêter',
                style: TextStyle(color: Colors.white, fontSize: 14)),
          )
        : ElevatedButton(
            onPressed: () {
              final timer = context.read<TimeModel>();
              timer.start();
            }, // Texte pour le bouton "Démarrer" avec le style
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[900],
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(34),
            ),
            child: const Text('Démarrer',
                style: TextStyle(color: Colors.white, fontSize: 14)),
          );
  }

  Widget buildClearButton(
      BuildContext context, TimeModel value, Box myBox, bool hasNumber) {
    return ElevatedButton(
      onPressed: () =>
          scanImage(context), // Texte pour le bouton ". ." avec le style
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
      child: const Text('. .',
          style: TextStyle(color: Colors.white, fontSize: 24)),
    );
  }

  Widget buildLapsList(TimeModel value) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 10 / 5,
        child: SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
              itemCount: value.laps.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lap ${value.laps.length - index}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          value.laps[value.laps.length - index - 1],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.white,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
