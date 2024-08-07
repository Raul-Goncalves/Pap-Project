import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:papproject/Screens/adminScreen.dart';
import 'package:papproject/authection/registerScreen.dart';
import 'package:papproject/authection/resPasswordScreen.dart';
import 'package:papproject/widgets/toast.dart';
import '../Screens/homeScreen.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String _error = 'ALGO DEU ERRADO!: ';
  bool _isSigningUp = false;

  void _login() async {
    if (_globalKey.currentState!.validate()) {
      setState(() {
        _isSigningUp = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text);
        showToast(message: 'Seja bem-vindo ${userCredential.user?.email}');
        if(userCredential.user?.email == 'admin@teste.com'){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => adminScreen()));
        }else{
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homeScreen()));
        }
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
        showToast(message: _error);
      } finally {
        setState(() {
          _isSigningUp = false;
        });
      }
    } else {
      showToast(message: 'Todos os campos devem ser preenchidos corretamente.');
    }
  }

  void _navigatorToRegister() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => registerScreen()));
  }

  void _navigatorToForgotPassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => resPasswordScreen()));
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
              child: Form(
                key: _globalKey,
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
                          ).createShader(
                              Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _emailController.text.isEmpty
                            ? Colors.white
                            : Colors.green,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _passwordController.text.isEmpty
                            ? Colors.white
                            : Colors.green,
                        hintText: 'Senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        return null;
                      },
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
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
                            ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}