import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestart/phoneAuth/otpScreen.dart';
import 'package:flutter/material.dart';

class Phoneauth extends StatefulWidget {
  const Phoneauth({super.key});

  @override
  State<Phoneauth> createState() => _PhoneauthState();
}

class _PhoneauthState extends State<Phoneauth> {
  TextEditingController phcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Auth'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: phcontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Hone Number",
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.verifyPhoneNumber(
                verificationCompleted: (PhoneAuthCredential credential) {},
                verificationFailed: (FirebaseAuthException ex) {},
                codeSent: (String verificationid, int? resendtoken) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Otpscreen(verificationId: verificationid,)),
                  );
                },
                codeAutoRetrievalTimeout: (String verificationID) {},
                phoneNumber: phcontroller.text.toLowerCase(),
              );
            },
            child: Text("Verify Phone Number"),
          ),
        ],
      ),
    );
  }
}
