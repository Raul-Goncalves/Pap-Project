import 'package:flutter/material.dart';
import 'package:papproject/Screens/loadingScreen.dart';

void main(){
  runApp(const papProject());
}


class papProject extends StatelessWidget {
  const papProject({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: loadingScreen(),
    );
  }
}
