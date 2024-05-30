import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:papproject/Screens/profileScreen.dart';

import 'loginScreen.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  void _onClickWithButton() {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    User? user = _auth.currentUser;

    if(user == null){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const loginScreen()));
    }else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const profileScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TextField(
            decoration: InputDecoration(
                hintText: "Pesquise Aqui.",
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.location_city, color: Colors.grey),
                suffixIcon: GestureDetector(
                  onTap: _onClickWithButton,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/back_ground.png"),
                    radius: 10,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0)),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: "Paragens"),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: "Horários"),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus), label: "Ônibus"),
        ],
      ),
    );
  }
}
