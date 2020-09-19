import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import './bottomNav.dart';
import './playgame.dart';
import './profile.dart';
import './loadImage.dart';
import './uploadImage.dart';

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
      body: SingleChildScrollView(
            child :  Column(
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                width: 200,
                height: 40,
                child: RaisedButton(              
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: BorderSide(color: Colors.blue)),
                  textColor: Colors.white,
                  //color: Colors.blue,
                  child: Text("create"),
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => uploadImagePage(uid: widget.uid)));
                      },
                    )
                  ),
                //ImageContainer(uid : widget.uid)
                Container(
                margin: EdgeInsets.only(bottom: 20),
                width: 200,
                height: 40,
                child: RaisedButton(              
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: BorderSide(color: Colors.blue)),
                  textColor: Colors.white,
                  //color: Colors.blue,
                  child: Text("Load"),
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImageContainer(uid : widget.uid)));
                      },
                    )
                  ),
            ],          
        ),
      ),
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