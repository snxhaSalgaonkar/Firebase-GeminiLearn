import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => PpickImageState();
}

class PpickImageState extends State<PickImage> {
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
        await getDescriptionFromBytes(bytes);
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
        // Get description
        getDescription(_image!);
      }
    }
  }

  Future<void> getDescription(File image) async {
    final bytes = await image.readAsBytes();
    try {
      final result = await Gemini.instance.textAndImage(
        text: prompt,
        images: [bytes],
      );
      setState(() {
        description = result?.output ?? 'No description provided';
      });
    } catch (e) {
      setState(() {
        description = 'error: ::: $e';
      });
    }
  }

  Future<void> getDescriptionFromBytes(Uint8List bytes) async {
    try {
      final result = await Gemini.instance.textAndImage(
        text: prompt,
        images: [bytes],
      );
      setState(() {
        description = result?.output ?? 'No description provided';
      });
    } catch (e) {
      setState(() {
        description = 'error: ::: $e';
      });
    }
    print(description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload and Describe Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 20),
            if (kIsWeb && _webImageBytes != null)
              Image.memory(_webImageBytes!, height: 200)
            else if (_image != null)
              Image.file(_image!, height: 200)
            else
              const Text('No image selected.'),
            const SizedBox(height: 20),
            Text(
              description.isNotEmpty
                  ? description
                  : 'Image description will appear here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
