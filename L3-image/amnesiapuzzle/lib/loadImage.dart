import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './gamepage.dart';


// class getFirebaseImageFolder extends StatefulWidget {
//   getFirebaseImageFolder({Key key, this.uid}) : super(key : key);
//   final String uid;
//   @override
//   _getFirebaseImageFolderState createState() => _getFirebaseImageFolderState();
// }

// class _getFirebaseImageFolderState extends State<getFirebaseImageFolder> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }

class ImageContainer extends StatefulWidget {
  ImageContainer({Key key, this.uid}) : super(key : key);
  final String uid;
  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  
  //List PicList;
  Future getFirebaseImageFolder(String uid) async {
    List PicList = [{"url": "https://firebasestorage.googleapis.com/v0/b/amnesiapuzzle.appspot.com/o/images%2Fw386V3dzLvh9EvQvSp6y1X5H6He2%2F2020-07-16%2017%3A00%3A22.497803.png?alt=media&token=cb535d08-66ce-4fa1-9d58-14bd9551abc0"}];
    await FirebaseDatabase.instance.reference().child('images/' + uid).once().then((Snapshot) {
      print("get data successfully");
      print(Snapshot.value);
      List PicTemList = [];
      Snapshot.value.forEach((key, val) {
        print(key);
        print(val);
        PicList.add(val);
        //PicTemList.add(val);
      });
      // PicList = PicTemList;
    }).catchError(
      (Error) {
        print(Error);    
      }
    );
    return PicList;
  }

  saveImage(String imageUrl) async {
    print("Go to game page");
    var response = await get(imageUrl);
    var documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(
          join(documentDirectory.path, './assets/imagetest.png')
      );
    file.writeAsBytesSync(response.bodyBytes);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(MediaQuery.of(context).size, snapshot.data[index]['url'], 3)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gallery")),
      body: Stack(
        children: <Widget>[
          SizedBox(height: 20),
          Text("Gallery"),
          SingleChildScrollView(
            child: FutureBuilder(
              future: getFirebaseImageFolder(widget.uid),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    print("None");
                    return(Text("None Connection"));
                  case ConnectionState.waiting:
                    print("waiting");
                    return(Text("waiting to Connection"));
                  case ConnectionState.active:
                    print("active");
                    return Center(
                    child: CircularProgressIndicator());
                  case ConnectionState.done:
                    print("done");
                    child:print('Data Loading Done');
                      if (snapshot.hasData) {
                        print("Show snapshot");
                        print(snapshot.data);
                        return Container(
                          //child: Text("Good")
                          height: 600.0,
                          child:ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,                            
                            itemBuilder: (BuildContext context, int index) {
                                return 
                                Container(
                                  height: 200,
                                  child: InkWell(onTap: () {
                                    Navigator.push(
                                        //context, MaterialPageRoute(builder: (context) =>  GamePage(MediaQuery.of(context).size, snapshot.data[index]['url'], 3))
                                        context, MaterialPageRoute(builder: (context) =>  GamePage(MediaQuery.of(context).size, snapshot.data[index]['filepath'], 3))
                                        //context, MaterialPageRoute(builder: (context) => uploadImagePage(uid:val.user.uid))
                                    );
                                  },
                                  //child: InkWell(onTap: () => saveImage(snapshot.data[index]['url']),
                                  child: Image.network(snapshot.data[index]['url']))
                                  );
                                //Text(snapshot.data[index]['url']);
                                // SizedBox(height:10),
                                // Text("Good");
                              }
                            )
                        );
                      } else {
                        return Center(child:Text("No Picture Loaded"));
                      }
                }

              }
            )
          )
        ],

      //   Column(children: <Widget>[
      //   Text("Gallery"),

      //   // RaisedButton(
      //   //   child: Text("Press"),
      //   //   //"get image data",
      //   //   onPressed: () {
      //   //     getFirebaseImageFolder(widget.uid);
      //   //   },
      //   // ),

      // ])
      )
    );

  }
  // Widget build(BuildContext context) {
  //   return Stack(
  //     children: <Widget>[
  //       SingleChildScrollView(
  //         child: Column(
  //           children: <Widget>[
  //             SizedBox(height: 20.0),
  //             Text("Your Images are",
  //             style: TextStyle(
  //                 color: Colors.lightBlueAccent,
  //                 fontSize: 30,
  //                 fontWeight: FontWeight.w900
  //               )
  //             ),
  //             FutureBuilder(
  //               future: getFirebaseImageFolder(widget.uid),
  //               builder: (context, snapshot) {
  //                 switch (snapshot.connectionState) {
  //                   case ConnectionState.none:
  //                     print('Not start yet');
  //                     return Text('Not start yet');
  //                   case ConnectionState.active:
  //                     print('active yet');
  //                     return Text('active yet');
  //                   case ConnectionState.waiting:
  //                     print('waiting');
  //                     return Text('waiting');
  //                   case ConnectionState.done:
  //                     print('done');
  //                     return Text('done');
  //                 }
  //               }
  //             )
  //           ],
  //         )
  //       )
  //     ],
  //   );
  // }
}

    // final StorageReference storageRef =
    //     FirebaseStorage.instance.ref().child('gs://amnesiapuzzle.appspot.com/images/');
    // storageRef.listAll().then((result) {
    //   print("result is $result");
    //   return result;
    // });