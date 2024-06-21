import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papproject/Screens/homeScreen.dart';

import '../../widgets/toast.dart';

class resPasswordScreen extends StatefulWidget {
  const resPasswordScreen({super.key});

  @override
  State<resPasswordScreen> createState() => _resPasswordScreenState();
}

class _resPasswordScreenState extends State<resPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        showToast(message: "Email de redefinição de senha enviado com sucesso.");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen()));

      } catch (e) {
        showToast(message: "Erro ao enviar email: ${e.toString()}");
      } finally {
        setState(() {
          _isSending = false;
        });
      }
    } else {
      showToast(message: "Por favor, insira um email válido.");
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
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.0),
              ),
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Repor Senha',
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
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _emailController.text.isEmpty ? Colors.white : Colors.green,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isSending ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSending
                          ? CircularProgressIndicator(color: Colors.blue)
                          : Text(
                        'Enviar email',
                        style: TextStyle(
                          fontSize: 25,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Color(0xFF000000),
                                Color(0xFF4432B0),
                                Color(0xFF0000FF),
                              ],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}