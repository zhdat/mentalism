import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimeModel extends ChangeNotifier {
  final _myBox = Hive.box('Data');

  int miliseconds = 0;
  int seconds = 0;
  int minutes = 0;

  String digitMiliseconds = '00';
  String digitSeconds = '00';
  String digitMinutes = '00';

  bool started = false;
  Timer? timer;
  List<String> laps = [];

  bool isPairMode = true;

  void stop() {
    timer?.cancel();
    if (_myBox.length != 0) {
      digitMiliseconds = ((_myBox.get(0)).length >= 2)
          ? "${_myBox.get(0)}"
          : "${miliseconds ~/ 10}${_myBox.get(0)}";
    }
    started = false;
    notifyListeners();
  }

  void reset() {
    seconds = 0;
    minutes = 0;
    miliseconds = 0;

    digitMiliseconds = '00';
    digitSeconds = '00';
    digitMinutes = '00';

    laps = [];
    notifyListeners();
  }

  void lap() {
    laps.add('$digitMinutes:$digitSeconds:$digitMiliseconds');
    notifyListeners();
  }

  void start() {
    started = true;
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      int localMilliseconds = miliseconds + 1;
      int localSeconds = seconds;
      int localMinutes = minutes;

      if (localMilliseconds > 99) {
        if (localSeconds > 59) {
          localMinutes++;
          localSeconds = 0;
        } else {
          localSeconds++;
          localMilliseconds = 0;
        }
      }

      miliseconds = localMilliseconds;
      seconds = localSeconds;
      minutes = localMinutes;
      digitMiliseconds = (miliseconds >= 10) ? "$miliseconds" : "0$miliseconds";
      digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
      digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      notifyListeners();
    });
  }

  void toggleMode() {
    isPairMode = !isPairMode;
    notifyListeners();
  }

  String getMilliseconds() {
    return digitMiliseconds;
  }
}
