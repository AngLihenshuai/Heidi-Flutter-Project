import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './profile.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Demo')
      ),
      body: Center(child: Column(
        children: <Widget>[
          Expanded(
            flex: 40,
            child: Image.asset("assets/pic1.png",
              fit: BoxFit.cover)
          ),
          SizedBox(
            height: 100,
            child: Center(child: Text("Sign up", style: TextStyle(color: Color.fromARGB(0xFF, 0x42, 0xA5, 0xF5), fontSize: 40))
          )),
          Container(
            margin: EdgeInsets.only(top:10, left:20, right:20),
            width: 400,
            child: TextField(
              controller: emailController,
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Email",
                border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            width: 400,
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "password",
                border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            ),
          ),
          SizedBox(height: 30),
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
              child: Text("Sign Up"),
              onPressed: () {
                  Future AuthRes = FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text, 
                    password: passwordController.text).then((val) {
                      print("Successful Sign up");
                      print(val.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(uid:val.user.uid)));
                    }).catchError((error) {
                      print(error.toString());
                    });
                },
            )
          )
        ]
      ),  
    ));
  }
}
