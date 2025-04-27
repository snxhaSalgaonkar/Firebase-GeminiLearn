import 'package:firebasestart/function/uihelper.dart';
import 'package:flutter/material.dart';

class phoneemail extends StatefulWidget {
  const phoneemail({super.key});

  @override
  State<phoneemail> createState() => _phoneemailState();
}

class _phoneemailState extends State<phoneemail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Choose mode of authentication',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          UIhelper.customButton(() {}, "Phone Authentication"),
          SizedBox(height: 10),
          UIhelper.customButton(() {}, "Email Authentication"),
        ],
      ),
    );
  }
}
