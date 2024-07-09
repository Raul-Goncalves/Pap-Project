import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papproject/Screens/homeScreen.dart';
import 'package:papproject/Screens/tradeClockScreen.dart';

class adminScreen extends StatefulWidget {
  const adminScreen({super.key});

  @override
  State<adminScreen> createState() => _adminScreenState();
}

class _adminScreenState extends State<adminScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void _navegarParaEdicaoHorarios(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tradeClockScreen()),
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

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => homeScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tela Admin:",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
             onPressed: () => _confirmSignOut(context)
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navegarParaEdicaoHorarios(context),
          child: Text('Editar Horários'),
        ),
      ),
    );
  }
}
