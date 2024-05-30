import 'package:flutter/material.dart';
import 'package:papproject/Screens/loadingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'FireBase/firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(papProject());
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
