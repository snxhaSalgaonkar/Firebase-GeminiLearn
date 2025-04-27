import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestart/emailAuth/login.dart';
import 'package:firebasestart/homepage.dart';
import 'package:flutter/material.dart';

class Checkuser extends StatefulWidget {
  const Checkuser({super.key});

  @override
  State<Checkuser> createState() => _CheckuserState();
}

class _CheckuserState extends State<Checkuser> {
  Future<Widget> checkUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return Homepage();
    } else {
      return loginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkUser(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // You can show a loading indicator here while waiting for the Future to complete
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors that might occur during the Future execution
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Once the Future completes successfully, snapshot.data will contain the Widget
          return snapshot.data!;
        } else {
          // This should ideally not be reached if your logic is sound
          return const SizedBox.shrink(); // Or some default empty widget
        }
      },
    );
  }
}
