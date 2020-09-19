import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'uploadImage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      //home: ImageContainer()
      home: SignInPage(title: 'Firebase Auth Demo'),
      //home: TestingDownload(), 
      //home: uploadImagePage()
      //home: HomePage()
      //home: ImageContainer()
    );
  }
}