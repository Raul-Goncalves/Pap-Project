import 'package:flutter/material.dart';
import 'package:papproject/Screens/registerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:papproject/Screens/resPasswordScreen.dart';
import 'package:papproject/widgets/toast.dart';

import 'homeScreen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _error = '';
  bool _isSigningUp = false;

  void _login() async {
    setState(() {
      _isSigningUp = true;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _isSigningUp = false;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        showToast(message: 'Todos os campos devem ser preenchidos.');
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      showToast(message: 'Seja bem-vindo ${userCredential.user?.email}');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen()));
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

  void _navigatorToRegister() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => registerScreen()));
  }

  void _navigatorToForgotPassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => resPasswordScreen()));
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
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.0),
              ),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _navigatorToForgotPassword();
                      },
                      child: Text(
                        'Esqueceu a senha.',
                        style: TextStyle(
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
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSigningUp
                        ? CircularProgressIndicator(
                      color: Colors.blue,
                    )
                        : Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 25,
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
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _navigatorToRegister();
                    },
                    child: Text(
                      'Ainda não tem conta: Criar agora.',
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
