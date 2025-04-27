// import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

// import 'package:firebasestart/emailAuth/forgotpassword.dart';
// import 'package:firebasestart/emailAuth/signUp.dart';
// import 'package:firebasestart/function/uihelper.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class Imageupload extends StatefulWidget {
//   const Imageupload({super.key});

//   @override
//   State<Imageupload> createState() => _ImageuploadState();
// }

// class _ImageuploadState extends State<Imageupload> {
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();
//   File? pickedImage;

//   showAlertBox() {
//     return showDialog(
//       context: context,
//       builder: (BuildContext conttext) {
//         return AlertDialog(
//           title: Text('Pick Image From'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 onTap: () {
//                   pickImage(ImageSource.camera);
//                   //Navigator.pop(context);
//                 },
//                 leading: Icon(Icons.camera),
//                 title: Text('Camera'),
//               ),

//               ListTile(
//                 onTap: () {
//                   pickImage(ImageSource.gallery);
//                 },
//                 leading: Icon(Icons.image),
//                 title: Text('Gallery'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   pickImage(ImageSource imagesource) async {
//     try {
//       final photo = await ImagePicker().pickImage(source: imagesource);
//       if (photo == null) {
//         return;
//       }
//       final tempImage = File(photo.path);
//       setState(() {
//         pickedImage = tempImage;
//       });
//     } catch (ex) {
//       log(ex.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login Page"),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 150, 197, 236),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               showAlertBox();
//             },
//             child:
//                 pickedImage != null
//                     ? CircleAvatar(
//                       radius: 50,
//                       backgroundImage: FileImage(pickedImage!),
//                     )
//                     : CircleAvatar(radius: 50, child: Icon(Icons.person)),
//           ),

//           // CircleAvatar(
//           //   radius: 50,
//           //   child: GestureDetector(
//           //     onTap: () {
//           //       showAlertBox();
//           //     },
//           //     child: Icon(Icons.person, size: 40),
//           //   ),
//           // ),
//           UIhelper.customTextField(emailcontroller, 'Email', Icons.mail, false),
//           SizedBox(height: 15),
//           UIhelper.customTextField(
//             passwordcontroller,
//             'Password',
//             Icons.password,
//             true,
//           ),
//           SizedBox(height: 40),

//           //signUp buttom
//           UIhelper.customButton(() {}, "Login"),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Already have an Account?'),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => signup()),
//                   );
//                 },
//                 child: Text(
//                   "Sign Up",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => forgotPasswpor()),
//               );
//             },
//             child: Text('Forgot Password?', style: TextStyle(fontSize: 15)),
//           ),
//         ],
//       ),
//     );
//   }
// }
