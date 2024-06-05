import 'package:flutter/material.dart';

class resPasswordScreen extends StatefulWidget {
  const resPasswordScreen({super.key});

  @override
  State<resPasswordScreen> createState() => _resPasswordScreenState();
}

class _resPasswordScreenState extends State<resPasswordScreen> {
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
                  borderRadius: BorderRadius.circular(15.0)
              ),
              width: 300,
              child:  Column(
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
                  TextField(
                    controller: null,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
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
          )
        ],
      ),
    );
  }
}
