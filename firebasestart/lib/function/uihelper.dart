import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UIhelper {
  static customTextField(
    TextEditingController controllerrr,
    String text,

    IconData icondataa,
    bool toHide,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: controllerrr,
        obscureText: toHide,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(icondataa),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }

  static customButton(VoidCallback voidCallback, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: SizedBox(
        height: 50,
        // width: 150,
        child: ElevatedButton(
          onPressed: () {
            voidCallback();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: const Color.fromARGB(255, 150, 197, 236),
          ),
          // style: ButtonStyle(
          //   backgroundColor: MaterialStateProperty.all(
          //     const Color.fromARGB(255, 102, 172, 230),
          //   ),
          // ),
          child: Text(
            text,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  static customAlertbox(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (BuildContext contec) {
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
