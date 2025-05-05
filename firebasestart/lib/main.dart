import 'package:firebasestart/gemini/imagedata.dart';
import 'package:firebasestart/gemini/imagepick.dart';
import 'package:firebasestart/uploadImage/cloudinaryEg.dart';
import 'package:firebasestart/uploadImage/start1.dart';
import 'package:firebasestart/uploadImage/start2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';

const apikey = 'AIzaSyCK10aDLmM4j5BYQy8-jqpTDFmB4Zjn5cY';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: apikey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase learn',
      home: CloudinaryExample(),
    );
  }
}
