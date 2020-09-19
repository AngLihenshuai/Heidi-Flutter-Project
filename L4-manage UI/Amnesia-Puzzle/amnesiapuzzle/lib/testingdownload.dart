import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import './gamepage.dart';
import 'dart:ui' as ui show instantiateImageCodec, Codec, Image;
import 'dart:ui';

class TestingDownload extends StatefulWidget {
  @override
  _TestingDownloadState createState() => _TestingDownloadState();
}

class _TestingDownloadState extends State<TestingDownload> {

  static Future<String> createFolderInAppDocDir(String folderName) async {

    //Get this App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =  Directory('${_appDocDir.path}/$folderName/');

    if(await _appDocDirFolder.exists()){ //if folder already exists return path
      return _appDocDirFolder.path;
    }else{//if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    String folderName = await createFolderInAppDocDir("CusImage");
    print(folderName);
    File file = File(folderName + '/test3.jpg');
    
    // new File(
    //   directory.path +  '/image/test1.png'
    // );
    print(file.runtimeType);
    // final File file1 = File('${directory.path}/my_file.txt');
    // await file1.writeAsString("Good");
    //print("write");
    final imageBytes = await getFromFirebase("images/w386V3dzLvh9EvQvSp6y1X5H6He2/1_free.jpg");
    print(imageBytes);
    //file.writeAsBytesSync(imageBytes);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  Future readImage() async {
    final directory = await getApplicationDocumentsDirectory();
    String folderName = await createFolderInAppDocDir("CusImage");
    print(folderName);
    File file = File(folderName + '/test3.png');
    try {      
      // Read the file.
      var contents = file.readAsBytesSync();
      print(contents);      
      ui.Codec codec = await ui.instantiateImageCodec(contents);      
      FrameInfo frameInfo = await codec.getNextFrame();
      var image = frameInfo.image;
      print("Run Time Type");
      print(image.runtimeType);        
    } catch (e) {
      // If encountering an error, return 0.
      print(e);
    }
  }

  Future getFromFirebase(String path) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(path);
    var imageBytes;
    await ref.getData(100000000).then((data) {        
        imageBytes = data;
        //print(imageBytes);        
      }).catchError((onError) {
        print(onError);
        imageBytes = null;
      });
    return imageBytes;
    }

  testGame() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(MediaQuery.of(context).size, "gametest", 4)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("testing")),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () => _localFile,
              child: Text("write")
            ),
            RaisedButton(
              onPressed: () => readImage(),
              child: Text("read")
            ),
            RaisedButton(
              onPressed: () => testGame(),
              child: Text("test")
            )
          ],
        )        
      )
    );
  }
}