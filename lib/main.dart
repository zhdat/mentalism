import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mentalism/model/time_model.dart';
import 'package:mentalism/view/home_page_android.dart';
import 'package:mentalism/view/home_page_ios.dart';
import 'package:mentalism/view/setting_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('Data');
  box = box;
  box.clear();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TimeModel>(create: (_) => TimeModel()),
    ],
    child: const MyApp(),
  )); // MutliProvider
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 2;
  String _selectedUI = 'Apple';
  bool get isApple => _selectedUI == 'Apple';
  bool get isAndroid => _selectedUI == 'Android';


  setselectedIndex(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  // Update UI style
  void updateUIStyle(String uiStyle) {
    setState(() {
      _selectedUI = uiStyle;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: isApple
            ? Colors.black
            : const Color.fromARGB(255, 21, 3, 1),
        // The body of the home page
        body: [
          SettingPage(
            onUIStyleChanged: updateUIStyle,
            selectedUI: _selectedUI,
          ),
          SettingPage(
            onUIStyleChanged: updateUIStyle,
            selectedUI: _selectedUI,
          ),
          isApple
              ? const HomePageIos()
              : const HomePageAndroid(),
          SettingPage(
            onUIStyleChanged: updateUIStyle,
            selectedUI: _selectedUI,
          ),
        ][_selectedIndex],
        bottomNavigationBar: isApple
            ? _buildAppleNavigationBar()
            : _buildAndroidNavigationBar(),
      ),
    );
  }

  Widget _buildCustomNavigationBar({
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor,
      currentIndex: _selectedIndex,
      onTap: (index) => setselectedIndex(index),
      selectedItemColor: selectedItemColor ?? Colors.blue,
      unselectedItemColor: unselectedItemColor ?? Colors.grey,
      unselectedFontSize: 14,
      selectedFontSize: 14,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.language),
          label: 'Horloges',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Alarmes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: 'Chronomètre',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.av_timer),
          label: 'Minuteurs',
        ),
      ],
    );
  }

  Widget _buildAppleNavigationBar() {
    return _buildCustomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.white,
    );
  }

  Widget _buildAndroidNavigationBar() {
    return _buildCustomNavigationBar(
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.blue[200],
      unselectedItemColor: Colors.white,
    );
  }
}
