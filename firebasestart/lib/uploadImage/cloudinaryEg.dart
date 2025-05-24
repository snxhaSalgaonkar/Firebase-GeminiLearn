import 'dart:convert';
import 'package:firebasestart/uploadImage/control/varaible.dart';
import 'package:firebasestart/uploadImage/demo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryExample extends StatefulWidget {
  @override
  _CloudinaryExampleState createState() => _CloudinaryExampleState();
}

class _CloudinaryExampleState extends State<CloudinaryExample> {
  String? _imageUrl;

  File? _imagefile;
  bool _isUploading = false;
  Uint8List? _webImageBytes; // Web only
  http.MultipartFile? _pickedMultipartFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() {
      _imageUrl = null;
      _imagefile = null;
      _webImageBytes = null;
      _pickedMultipartFile = null;
      imageurl = null;
    });

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _webImageBytes = bytes;
        _pickedMultipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: pickedFile.name,
        );
      });
    } else {
      final file = File(pickedFile.path);
      setState(() {
        _imagefile = file;
      });
      _pickedMultipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_pickedMultipartFile == null) return;
    setState(() {
      _isUploading = true;
    });

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dmqonkbka/upload');
    final request =
        http.MultipartRequest("POST", url)
          ..fields['upload_preset'] = 'learnbackend'
          ..fields['folder'] = 'flutter1'
          ..files.add(_pickedMultipartFile!);
    print("Resquest send");
    print("$request");

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        setState(() {
          _imageUrl = jsonMap['secure_url'];
          imageurl = _imageUrl; // stores the Cloudinary URL
        });
        print('Upload successful: $_imageUrl');
      } else {
        print('Upload failed: ${response.statusCode}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed. Try again.')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during upload')),
      );
    } finally {
      if (mounted) {
        print("mounted");
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cloudinary Upload")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('pickimage');
                  _pickImage();
                },
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),

              if (kIsWeb && _webImageBytes != null)
                Image.memory(_webImageBytes!, height: 200)
              else if (!kIsWeb && _imagefile != null)
                Image.file(_imagefile!, height: 200),

              if (_pickedMultipartFile != null)
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadImage,
                  child:
                      _isUploading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Upload to Cloudinary"),
                ),

              SizedBox(height: 20),
              if (_imageUrl != null) ...[
                Text(_imageUrl!),
                Image.network(_imageUrl!),
                SizedBox(height: 20),
                SelectableText(
                  " Cloundinary URL: $_imageUrl",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Demo()),
                    );
                  },
                  child: Text('Show Url'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
