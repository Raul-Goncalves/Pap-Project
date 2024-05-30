import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papproject/Screens/homeScreen.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/back_ground.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 375,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize:  MainAxisSize.min,
                          children: [
                            CircleAvatar(radius: 115, backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                            ),
                            SizedBox(height: 10),
                            Text("Teste", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      width: 50,
                      height: 50,
                      top: 0,
                      left: 0,
                      child: IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.red),
                        onPressed: () => _confirmSignOut(context),
                      ),
                    ),
                    const Positioned(
                      width: 50,
                      height: 50,
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: (null) ,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja sair da conta?'),
          actions: [
            TextButton(
              onPressed: () {
                _logout();
                Navigator.of(context).pop();
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Não'),
            ),
          ],
        );
      },
    );
  }
}

