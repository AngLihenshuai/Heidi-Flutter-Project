import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './gamepage.dart';

class ImageContainer extends StatefulWidget {
  ImageContainer({Key key, this.uid}) : super(key : key);
  final String uid;
  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {  
  Future getFirebaseImageFolder(String uid) async {    
    List PicTemList = [];
    await FirebaseDatabase.instance.reference().child('images/' + uid).once().then((Snapshot) {
      print("get data successfully");
      print(Snapshot.value);      
      Snapshot.value.forEach((key, val) {
        print(key);
        print(val);
        PicTemList.add(val);        
      });      
    }).catchError(
      (Error) {
        print(Error);
      }
    );
    return PicTemList;
  }

  saveImage(String imageUrl) async {
    print("Go to game page");
    var response = await get(imageUrl);
    var documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(
          join(documentDirectory.path, './assets/imagetest.png')
      );
    file.writeAsBytesSync(response.bodyBytes);    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gallery")),
      body: Container(child: SingleChildScrollView(
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
                        return   Container(                          
                          height: 600.0,
                          child:GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                                        context, MaterialPageRoute(builder: (context) =>  GamePage(MediaQuery.of(context).size, snapshot.data[index]['filepath'], 3))                                        
                                    );
                                  },
                                  //child: InkWell(onTap: () => saveImage(snapshot.data[index]['url']),
                                  child: Card(
                                        elevation: 1.5,
                                        child: Image.network(snapshot.data[index]['url']),
                                      ),
                                  ));
                                //Text(snapshot.data[index]['url']);
                                // SizedBox(height:10),                                
                              }
                            )
                        );
                      } else {
                        return Center(child:Text("No Picture Loaded"));
                      }
                }
              }
            )
          )),
    );
  }  
}    