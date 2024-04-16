import 'package:flutter/material.dart';
import 'package:mentalism/main.dart';
import 'package:mentalism/tuto_pages/tuto_page_1.dart';
import 'package:mentalism/tuto_pages/tuto_page_2.dart';
import 'package:mentalism/tuto_pages/tuto_page_3.dart';
import 'package:mentalism/tuto_pages/tuto_page_4.dart';
import 'package:mentalism/tuto_pages/tuto_page_5.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  final Function(String) onUIStyleChanged;
  final String selectedUI;

  const OnBoardingScreen({
    Key? key,
    required this.onUIStyleChanged,
    required this.selectedUI,
  }) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 4);
              });
            },
            children: const [
              TutoPage1(),
              TutoPage2(),
              TutoPage3(),
              TutoPage4(),
              TutoPage5(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => {
                    _controller.jumpToPage(4),
                  },
                  child: const Text(
                    "Passer",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 5,
                  effect: const WormEffect(
                      dotColor: Colors.white,
                      activeDotColor: Color.fromARGB(255, 197, 237, 212)),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const MyApp();
                          }))
                        },
                        child: const Text("Terminer",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            )),
                      )
                    : GestureDetector(
                        onTap: () => {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          )
                        },
                        child: const Text("Suivant",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            )),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
