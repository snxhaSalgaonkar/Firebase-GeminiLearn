import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestart/emailAuth/forgotpassword.dart';
import 'package:firebasestart/emailAuth/signUp.dart';
import 'package:firebasestart/function/uihelper.dart';
import 'package:firebasestart/homepage.dart';
import 'package:firebasestart/main.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  signinFunct(String email, String password) async {
    if (email == "" && password == "") {
      UIhelper.customAlertbox(context, 'Enter Required Fields');
    } else {
      UserCredential? Usercredential;
      try {
        Usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
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
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 150, 197, 236),
      ),
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

          //signUp buttom
          UIhelper.customButton(() {
            signinFunct(
              emailcontroller.text.toString(),
              passwordcontroller.text.toString(),
            );
          }, "Login"),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an Account?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signup()),
                  );
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => forgotPasswpor()),
              );
            },
            child: Text('Forgot Password?', style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
