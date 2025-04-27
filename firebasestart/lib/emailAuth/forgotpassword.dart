import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestart/function/uihelper.dart';
import 'package:flutter/material.dart';

class forgotPasswpor extends StatefulWidget {
  const forgotPasswpor({super.key});

  @override
  State<forgotPasswpor> createState() => _forgotPasswporState();
}

class _forgotPasswporState extends State<forgotPasswpor> {
  TextEditingController emailidcontroller = TextEditingController();

  // forgotPasswordd(String email) async {
  //   if (email == '') {
  //     return UIhelper.customAlertbox(
  //       context,
  //       "Enter an Email to reset Password",
  //     );
  //   } else {
  //     try {
  //       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //       print("Password reset email sent (attempted) to: $email");
  //       // Consider showing a success message here
  //     } catch (e) {
  //       print("Error sending password reset email: $e");
  //       UIhelper.customAlertbox(
  //         context,
  //         "An error occurred while sending the reset email. Please try again later.", // More user-friendly error
  //       );
  //     }
  //   }
  // }

  forgotPasswordd(String email) async {
    print("Attempting to send password reset email to: $email");
    if (email == '') {
      print("Email is empty, showing alert.");
      return UIhelper.customAlertbox(
        context,
        "Enter an Email to reset Password",
      );
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        print("Password reset email sent (attempted) to: $email");
        // Consider showing a success message here
      } catch (e) {
        print("Error sending password reset email: $e");
        UIhelper.customAlertbox(
          context,
          "An error occurred while sending the reset email. Please try again later.", // More user-friendly error
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UIhelper.customTextField(
            emailidcontroller,
            'Enter Email',
            Icons.email,
            false,
          ),
          SizedBox(height: 20),
          UIhelper.customButton(() {
            forgotPasswordd(emailidcontroller.text.toString());
          }, 'Reset Password'),
        ],
      ),
    );
  }
}
