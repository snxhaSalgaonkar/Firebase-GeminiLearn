import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<void> pickAndUploadImage() async {
  // Step 1: Let the user choose an image from their phone
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    print("No image selected.");
    return;
  }

  // Step 2: Convert the picked image to a File (so we can upload it)
  File imageFile = File(pickedFile.path); // path is a String
  print("Image file path: ${pickedFile.path}");

  // Step 3: Create a unique name for the image (just a string)
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  print("Generated file name: $fileName");

  // Step 4: Create a place in Firebase Storage to put this file
  // We're putting it inside a folder called 'images' and naming it like 'images/1683048429231'
  Reference storageRef = FirebaseStorage.instance.ref().child(
    'images/$fileName',
  );

  // Step 5: Upload the file to that location
  UploadTask uploadTask = storageRef.putFile(imageFile);
  TaskSnapshot snapshot = await uploadTask;

  // Step 6: Get the download URL (web link to the image)
  String downloadUrl = await snapshot.ref.getDownloadURL();
  print("Image uploaded! URL: $downloadUrl");

  // ✅ Now you can store this URL in Firebase Firestore, or show it in your app
}

class upimage1 extends StatefulWidget {
  const upimage1({super.key});

  @override
  State<upimage1> createState() => _upimage1State();
}

class _upimage1State extends State<upimage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('upload Image')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 250,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  print("on pressed");
                  pickAndUploadImage();
                },
                child: Text('Upload Image'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
