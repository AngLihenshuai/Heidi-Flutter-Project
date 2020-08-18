import 'package:flutter/material.dart';
import 'uploadImage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      //home: ImageContainer()
      //home: SignInPage(title: 'Firebase Auth Demo'),
      //home: TestingDownload(), 
      home: uploadImagePage()
      //home: HomePage()
      //home: ImageContainer()
    );
  }
}