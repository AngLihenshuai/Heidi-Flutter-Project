import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show instantiateImageCodec, Codec, Image;
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './ImageNode.dart';

class PuzzleMagic {
  ui.Image image;
  double eachWidth;
  Size screenSize;
  double baseX;
  double baseY;

  int level;
  double eachBitmapWidth;

  // loading image...

  Future<ui.Image> init(String path, Size size, int level) async {
    print("Start Getting Image");
    print(path);
    await getImage(path);

    screenSize = size;
    this.level = level;
    eachWidth = screenSize.width * 0.8 / level;
    baseX = screenSize.width * 0.1;
    baseY = (screenSize.height - screenSize.width) * 0.5;

    eachBitmapWidth = (image.width / level);
    print("#######################################");
    print(eachBitmapWidth);
    return image;
  }

  // Future<ui.Image> getImage(String path) async {
  //   //ByteData data = await rootBundle.load(path);    
  //   Uri ImageUri= new Uri();
  //   NetworkAssetBundle networkAssetBundle = new NetworkAssetBundle(ImageUri);
  //   print("loading Image");
  //   ByteData data = await networkAssetBundle.load(path);
  //   print("Image loaded");
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  //   FrameInfo frameInfo = await codec.getNextFrame();
  //   image = frameInfo.image;
  //   return image;
  // }

  //Uint8List imageBytes;
  // load from firebase
  // Future getFromFirebase(String path) async {
  //   final StorageReference ref = FirebaseStorage.instance.ref().child(path);
  //   var imageBytes;
  //   await ref.getData(100000000).then((data) {
  //       print("ref");
  //       imageBytes = data;
  //     }).catchError((onError) {
  //       print(onError);
  //       imageBytes = null;
  //     });
  //   return imageBytes;
  //   }

  // Future<ui.Image> getImage(String path) async {
  //   //ByteData data = await rootBundle.load(path);        
  //   // Uri ImageUri= new Uri();
  //   // NetworkAssetBundle networkAssetBundle = new NetworkAssetBundle(ImageUri);
  //   print("loading Image");
  //   Uint8List data =  await getFromFirebase(path);
  //   //ByteData data = await getFromFirebase(path);
  //   print("The data is ");
  //   print(data);
  //   // ByteData data = await networkAssetBundle.load(path);
  //   print("Image loaded");
  //   ui.Codec codec = await ui.instantiateImageCodec(data);
  //   //ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  //   FrameInfo frameInfo = await codec.getNextFrame();
  //   image = frameInfo.image;
  //   print(image.runtimeType);
    
  //   return image;
  // }

  Future<ui.Image> getImage(String path) async { 
    //ByteData data = await rootBundle.load("/data/user/0/com.example.amnesiapuzzle/app_flutter/CusImage/test3.jpg"); 
    ByteData data = await rootBundle.load("assets/1_free.jpg"); 
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo frameInfo = await codec.getNextFrame();
    image = frameInfo.image;
    return image;
  }

  List<ImageNode> doTask() {
    List<ImageNode> list = [];
    for (int j = 0; j < level; j++) {
      for (int i = 0; i < level; i++) {
        if (j * level + i < level * level - 1) {
          ImageNode node = ImageNode();
          node.rect = getOkRectF(i, j);
          node.index = j * level + i;
          makeBitmap(node);
          list.add(node);
        }
      }
    }
    return list;
  }

  Rect getOkRectF(int i, int j) {
    return Rect.fromLTWH(
        baseX + eachWidth * i, baseY + eachWidth * j, eachWidth, eachWidth);
  }

  void makeBitmap(ImageNode node) {
    int i = node.getXIndex(level);
    int j = node.getYIndex(level);

    Rect rect = getShapeRect(i, j, eachBitmapWidth);
    rect = rect.shift(
        Offset(eachBitmapWidth.toDouble() * i, eachBitmapWidth.toDouble() * j));

    PictureRecorder recorder = PictureRecorder();
    double ww = eachBitmapWidth.toDouble();
    print("###############WW##############");
    print(ww);
    Canvas canvas = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, ww, ww));

    Rect rect2 = Rect.fromLTRB(0.0, 0.0, rect.width, rect.height);

    Paint paint = Paint();
    canvas.drawImageRect(image, rect, rect2, paint);
    recorder.endRecording().toImage(ww.floor(), ww.floor()).then((image){
        node.image = image;
    });
    node.rect = getOkRectF(i, j);
  }

  Rect getShapeRect(int i, int j, double width) {
    return Rect.fromLTRB(0.0, 0.0, width, width);
  }
}
