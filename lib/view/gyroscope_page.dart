import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class GyroscopeWidget extends StatefulWidget {
  const GyroscopeWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GyroscopeWidgetState createState() => _GyroscopeWidgetState();
}

class _GyroscopeWidgetState extends State<GyroscopeWidget> {
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  GyroscopeEvent? _latestGyroscopeEvent;

  @override
  void  initState(){
     super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _latestGyroscopeEvent = event;
      });/*
      a = 0;
      b = 0;
      c = 0;
      if (event.x > a) {
      } else if (event.y > b) {
      } else if (event.z > c) {
      }*/
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    super.dispose();
  }
  
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyroscope Data'),
      ),
      body: Center(
        child: Text(_latestGyroscopeEvent != null
            ? 'Gyroscope coordonnéess: ${_latestGyroscopeEvent!.x}, ${_latestGyroscopeEvent!.y}, ${_latestGyroscopeEvent!.z}' : 'Waiting for gyroscope data...'),
      ),
    );
  }
}