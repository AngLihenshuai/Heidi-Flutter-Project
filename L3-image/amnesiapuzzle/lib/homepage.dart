import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import './bottomNav.dart';
import './playgame.dart';
import './profile.dart';
import './loadImage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid}) : super(key : key);
  final String uid;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text(widget.uid)),
      // body: Center(child: Text("Homepage")),
      body: ImageContainer(uid : widget.uid),
      bottomNavigationBar: BottomNavBar(currentIndex : 0),
    );
  }
}

// class ImageLoader extends StatefulWidget {
//   @override
//   _ImageLoaderState createState() => _ImageLoaderState();
// }


// class _ImageLoaderState extends State<ImageLoader> {
//   final FirebaseStorage storage = FirebaseStorage(
//       app: Firestore.instance.app,
//       storageBucket: 'gs://amnesiapuzzle.appspot.com/');

//   Uint8List imageBytes;
//   String errorMsg;

//   _ImageLoaderState() {
//       storage.ref().child('selfies/me2.jpg').getData(10000000).then((data) =>
//                 setState(() {
//                   imageBytes = data;
//                 })
//         ).catchError((e) =>
//                 setState(() {
//                   errorMsg = e.error;
//                 })
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var img = imageBytes != null ? Image.memory(
//         imageBytes,
//         fit: BoxFit.cover,
//       ) : Text(errorMsg != null ? errorMsg : "Loading...");

//     return new Scaffold(
//         appBar: new AppBar(
//           title: new Text("Nice"),
//         ),
//         body: new ListView(
//           children: <Widget>[
//             img,
//           ],
//         ));
//   }
// }