import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasestart/function/uihelper.dart';
import 'package:flutter/material.dart';

class Adddata extends StatefulWidget {
  const Adddata({super.key});

  @override
  State<Adddata> createState() => _AdddataState();
}

class _AdddataState extends State<Adddata> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();

  Adddata(String title, String desc) async {
    if (title == '' || desc == '') {
      print("Enter Required Fields");
    } else {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(title)
          .set({"Title": title, "Description": desc})
          .then((value) {
            print("Data Inserted");
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Data'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UIhelper.customTextField(
            titlecontroller,
            "Enter Title",
            Icons.title,
            false,
          ),
          SizedBox(height: 10),
          UIhelper.customTextField(
            desccontroller,
            "Enter Description",
            Icons.description,
            false,
          ),
          SizedBox(height: 10),
          UIhelper.customButton(() {
            Adddata(
              titlecontroller.text.toString(),
              desccontroller.text.toString(),
            );
          }, "Add Data"),
        ],
      ),
    );
  }
}
