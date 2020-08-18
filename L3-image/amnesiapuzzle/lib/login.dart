import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './register.dart';
import './homepage.dart';
import 'uploadImage.dart';
import './profile.dart';

class SignInPage extends StatefulWidget {  
  SignInPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FirebaseUser user;
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

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
            child: Center(child: Text("Welcome to my app", style: TextStyle(color: Color.fromARGB(0xFF, 0x42, 0xA5, 0xF5), fontSize: 40))
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
            //margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),            
            width: 200,
            height: 40,
            child: RaisedButton(              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
                side: BorderSide(color: Colors.blue)),
              textColor: Colors.white,
              //color: Colors.blue,
              child: Text("Login"),
              // child: Container(
              //   width: 200,
              //   height: 30,                
              //   child: Text("Login"),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(32.0),
              //     gradient: LinearGradient(
              //     colors: <Color>[
              //       Color(0xFF0D47A1),
              //       Color(0xFF1976D2),
              //       Color(0xFF42A5F5),
              //       ]
              //     ),
              //   )),
              onPressed: (){
                FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text, 
                  password: passwordController.text).then((val) {
                    print("Sign in successful");
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HomePage(uid:val.user.uid))
                      //context, MaterialPageRoute(builder: (context) => uploadImagePage(uid:val.user.uid))
                    );
                  }).catchError((err) {
                    print(err.toString());
                  });
              },
            )
          ),
          SizedBox(height: 10),
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
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterPage()));
                },
            )
          )
        ]
      ),  
    ));
  }
}