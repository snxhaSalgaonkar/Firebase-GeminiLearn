import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class upImage2 extends StatefulWidget {
  const upImage2({super.key});

  @override
  State<upImage2> createState() => _upImage2State();
}

class _upImage2State extends State<upImage2> {
  File? _image;
  final picker = ImagePicker();
  String description = '';
  String prompt = 'Describe the image';

  Uint8List? _webImageBytes;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
        //await getDescriptionFromBytes(bytes);
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
        // Get description
        //getDescription(_image!);
      }
    }
  }

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
                  pickImage();
                },
                child:
                    _webImageBytes != null
                        ? Image.memory(_webImageBytes!, height: 200)
                        : Text('Upload image'),
              ),
            ),
          ),

          // const SizedBox(height: 20),
          // if (kIsWeb && _webImageBytes != null)
          //   Image.memory(_webImageBytes!, height: 200)
          // else if (_image != null)
          //   Image.file(_image!, height: 200)
          // else
          //   const Text('No image selected.'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
