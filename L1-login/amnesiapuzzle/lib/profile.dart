import "package:flutter/material.dart";

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.uid)),
      body: Container(
        child: Text("Profile")
      )
    );
  }
}