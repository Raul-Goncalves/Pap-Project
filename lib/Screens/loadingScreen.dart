import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:papproject/Screens/homeScreen.dart';
import 'package:papproject/Screens/teste.dart';

class loadingScreen extends StatefulWidget {
  const loadingScreen({super.key});

  @override
  State<loadingScreen> createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  bool isloagin = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isloagin = false;
      });
    });
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const homeScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            top: isloagin ? -320 : -125,
            left: -30,
            child: Transform.rotate(
              angle: -45 * 3.14159265359 / 180,
              child: Lottie.asset('assets/wave.json', width: 500, height: 500),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            bottom: isloagin ? -300 : -152,
            right: -40,
            child: Transform.rotate(
              angle: 135 * 3.14159265359 / 180,
              child: Lottie.asset('assets/wave.json', width: 500, height: 500),
            ),
          ),
        ],
      ),
    ));
  }
}
