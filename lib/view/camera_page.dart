import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mentalism/model/time_model.dart';
import 'package:mentalism/view/result_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final TextRecognizer textRecognizer = TextRecognizer();
  final _myBox = Hive.box("Data");

  bool _isPermissionGranted = false;

  late final Future<void> _future;

  // Add this controller to be able to control de camera
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  // We should stop the camera once this widget is disposed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  // Starts and stops the camera according to the lifecycle of the app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return _buildStack(context, snapshot);
      },
    );
  }

  Widget _buildStack(BuildContext context, AsyncSnapshot snapshot) {
    return Stack(
      children: [
        if (_isPermissionGranted)
          _buildCameraPreview(),
        Scaffold(
          appBar: AppBar(
            title: const Text('Text Recognition Sample'),
          ),
          backgroundColor: _isPermissionGranted ? Colors.transparent : null,
          body: _isPermissionGranted
              ? _buildCameraPermissionGrantedUI()
              : _buildCameraPermissionDeniedUI(),
        ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<List<CameraDescription>>(
      future: availableCameras(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _initCameraController(snapshot.data!);
          return Center(child: CameraPreview(_cameraController!));
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }

  Widget _buildCameraPermissionGrantedUI() {
    return Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Center(
            child: ElevatedButton(
              onPressed: _scanImage,
              child: const Text('Scan text'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPermissionDeniedUI() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: const Text(
          'Camera permission denied',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);
    final timeModel = Provider.of<TimeModel>(context, listen: false);

    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final recognizedText = await _processImage(file);
      final numbersOnly = _extractNumbers(recognizedText);
      final numbers = _filterNonNumericCharacters(numbersOnly);
      final pairNumbersList = _createPairNumbersList(numbers);

      await _storeNumbers(pairNumbersList, timeModel.isPairMode);

      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) => ResultScreen(text: numbers[3]),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  Future<String> _processImage(File file) async {
    final inputImage = InputImage.fromFile(file);
    final recognizedText = await textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  List<String> _extractNumbers(String text) {
    String numbersOnlyBis = text.replaceAll("A", "1");
    return numbersOnlyBis.replaceAll(RegExp(r'[^0-9]'), '').split('');
  }

  List<String> _filterNonNumericCharacters(List<String> numbers) {
    return numbers.where((char) => RegExp(r'^[0-9]$').hasMatch(char)).toList();
  }

  List<String> _createPairNumbersList(List<String> numbers) {
    List<String> pairNumbersList = [];
    for (int i = 0; i < numbers.length; i += 2) {
      if (i == 0 && numbers.length % 2 != 0) {
        pairNumbersList.add("0");
      }
      pairNumbersList.add(numbers[i] + numbers[i + 1]);
    }
    return pairNumbersList;
  }

  Future<void> _storeNumbers(List<String> numbers, bool isPairMode) async {
    for (int i = 0; i < numbers.length; i++) {
      await _myBox.put(i, numbers[i]);
    }
  }


}
