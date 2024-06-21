import 'package:flutter/material.dart';
import 'package:papproject/Screens/homeScreen.dart';
import 'package:papproject/Screens/lines/n11Screen.dart';
import 'package:papproject/Screens/lines/ubiScreen.dart';
import 'package:papproject/Screens/loadingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'FireBase/firebase_options.dart';
import 'Screens/lines/n10Screen.dart';
import 'Screens/lines/n12Screen.dart';


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
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => loadingScreen(),
        '/homeScreen': (context) => homeScreen(),
        '/n10Screen': (context) => n10Screen(),
        '/n11Screen': (context) => n11Screen(),
        '/n12Screen': (context) => n12Screen(),
        '/ubiScreen': (context) => ubiScreen(),
      },
    );
  }
}
