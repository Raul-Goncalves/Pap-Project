import 'package:flutter/material.dart';

class ubiScreen extends StatelessWidget {
  const ubiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Linha 11 - POLOIV - HOSPITAL",
          style: TextStyle(
              color:  Colors.white, fontSize: 15, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}