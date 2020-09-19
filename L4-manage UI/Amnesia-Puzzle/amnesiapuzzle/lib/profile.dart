import "package:flutter/material.dart";
import './bottomNav.dart';
import 'gamepage.dart';
import './homepage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.uid}) : super(key: key);
  final String uid;
  //ProfilePage(this.uid);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text(widget.uid)),
      body: Center(
        // child: GamePage(MediaQuery.of(context).size, 'assets/1_free.jpg', 3)
        child: Text("profile")
      ),
      bottomNavigationBar: BottomNavBar(currentIndex : 1),
    );
  }
}