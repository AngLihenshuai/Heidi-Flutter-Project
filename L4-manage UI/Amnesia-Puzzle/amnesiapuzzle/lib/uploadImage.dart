import 'dart:io';
//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class uploadImagePage extends StatefulWidget {
  uploadImagePage({Key key, this.uid}): super(key : key);
  final String uid;
  @override
  _uploadImagePageState createState() => _uploadImagePageState();
}

class _uploadImagePageState extends State<uploadImagePage> {
  /// Active image file  
  File _imageFile;
  var cropped_status = false;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ) 
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        // toolbarColor: Colors.purple,
        // toolbarWidgetColor: Colors.white,
        // toolbarTitle: 'Crop It'
      );
      

    setState(() {
      _imageFile = cropped ?? _imageFile;       
      cropped_status = true;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Select an image from the camera or gallery
      appBar: AppBar(title: Text("App Load your Image")),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
      
      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ]
            ),
            if (cropped_status != false) Uploader(file: _imageFile, uid: widget.uid)
          ] else ...[
            Center(child: Text("Please select one in bottom bar")),
          ]
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final String uid;
  Uploader({Key key, this.file, this.uid}) : super(key : key);

  @override
  _UploaderState createState() => _UploaderState(); 
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://amnesiapuzzle.appspot.com/');

  StorageUploadTask _uploadTask;

  Future<void> _downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
  }

  /// Starts an upload task
  void _startUpload() {

    /// Unique file name for the file
    String userid = widget.uid;

    // FirebaseAuth.instance.currentUser().then((user) {
    //    userid = user.uid;       
    // });
    //String DateTimeNow = DateTime.now().toString();
    String timeMilestone = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath = 'images/${userid}/${timeMilestone}.png';
    //String filePath = 'images/Testing/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
      _uploadTask.events.listen((event) {
        print('EVENT ${event.type}');
        if (event.type == StorageTaskEventType.success) {
          _storage.ref().child(filePath).getDownloadURL().then((url) {
            print(url);
            //String timeMilestone = DateTime.now().millisecondsSinceEpoch.toString();
            //.replaceAll(' ', '-').replaceAll('.', '-').replaceAll(':', '-');
            FirebaseDatabase.instance.reference().child('images/' + userid + '/' + timeMilestone).set({'url' : url, 'date' : DateTime.now().toString(),'filepath':filePath})
            //FirebaseDatabase.instance.reference().child('images/'+timeMilestone).push.set(<String, String> {'url' : url})
            .then((val){
              print("Upload successfully");
            }).catchError((onError) {
                print("Error Occurs");
                print(onError);
              });
          }).catchError((onError) {
            print(onError);
          });
        }
      });
    });
  }  

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;
            print('snapshot');
            print(event);
            
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
                
            return Column(
                children: [
                  if (_uploadTask.isComplete)
                    Text('🎉🎉🎉'),
                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause),
                      onPressed: _uploadTask.pause,
                    ),
                  // Progress bar
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % '
                  ),
                ],
              );
          });
    } else {

      // Allows user to decide when to start the upload
      return FlatButton.icon(
          label: Text('Upload to Firebase'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        );
    }
  }
}