import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestart/function/uihelper.dart';
import 'package:firebasestart/homepage.dart';
import 'package:flutter/material.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  signupp(String email, String password) async {
    if (email == '' && password == "") {
      UIhelper.customAlertbox(context, "Enter Required Field");
    } else {
      UserCredential? Usercredential;
      try {
        Usercredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            });
      } on FirebaseAuthException catch (ex) {
        return UIhelper.customAlertbox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UIhelper.customTextField(emailcontroller, 'Email', Icons.mail, false),
          SizedBox(height: 15),
          UIhelper.customTextField(
            passwordcontroller,
            'Password',
            Icons.password,
            true,
          ),
          SizedBox(height: 40),
          UIhelper.customButton(() {
            signupp(
              emailcontroller.text.toString(),
              passwordcontroller.text.toString(),
            );
          }, "Sign Up"),
        ],
      ),
    );
  }
}
