import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

inniConfiguration() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
}