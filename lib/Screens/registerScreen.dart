import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/toast.dart';
import 'homeScreen.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _error = '';
  bool _isSigningUp = false;

  void _register() async {
    setState(() {
      _isSigningUp = true;
    });

    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _isSigningUp = false;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        showToast(message: 'Todos os campos devem ser preenchidos.');
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('user').doc(user.uid).set({
          'name': _usernameController.text,
          'email': _emailController.text,
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen()),
        );
        showToast(message: "Usuário registrado com sucesso ${_usernameController.text}");
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }finally{
      setState(() {
        _isSigningUp = false;
      });
    }
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
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.0),
              ),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Registro',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Color(0xFF000000),
                            Color(0xFF4432B0),
                            Color(0xFF0000FF),
                          ],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                    ),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _usernameController.text.isEmpty ? Colors.white : Colors.green,
                      hintText: 'Usuário',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _passwordController.text.isEmpty ? Colors.white : Colors.green,
                      hintText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _emailController.text.isEmpty ? Colors.white : Colors.green,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      _isSigningUp ? null : _register();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSigningUp
                        ? CircularProgressIndicator(
                            color: Colors.blue,
                          )
                        : Text(
                            'Criar Conta',
                            style: TextStyle(
                              fontSize: 25,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF000000),
                                    Color(0xFF4432B0),
                                    Color(0xFF0000FF),
                                  ],
                                ).createShader(
                                    Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                            ),
                          ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Já tem uma conta?',
                      style: TextStyle(
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: <Color>[
                              Color(0xFF000000),
                              Color(0xFF4432B0),
                              Color(0xFF0000FF),
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
