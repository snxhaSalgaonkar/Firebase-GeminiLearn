import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class imageDesc extends StatefulWidget {
  const imageDesc({super.key});

  @override
  State<imageDesc> createState() => _imageDescState();
}

class _imageDescState extends State<imageDesc> {
  String prompt = '''
 Give me a tabular description of the object in the attached image. 
      the desciption should be in the format below 
      •	1.Name: What type of object is it? (e.g., helmet, phone, bag) 
•	2.Brand:
•	3.Model:
•	5.Color: Main colors and any special color patterns.
•	6.Size: Is it small, medium, large? Rough dimensions help.
•	7.Shape: What is the general shape? (round, rectangular, etc.)
•	8.Unique Marks: Any scratches, stickers, logos, designs, writing, 
Zippers, buttons, straps, logos, printed names, drawings, etc.

''';

  String outputt = '';
  void askgemini() async {
    try {
      print("fuction called");

      final bytes = await rootBundle.load('lib/assests/Vegahelmate.jpg');
      final imageData = bytes.buffer.asUint8List();

      print(
        'Image loaded successfully. Size: ${imageData.lengthInBytes} bytes',
      );

      final value = await Gemini.instance.textAndImage(
        text: prompt,
        images: [imageData],
      );
      setState(() {
        outputt =
            (value?.content?.parts?.first as TextPart).text ??
            "No description received.";
      });
      print(outputt);
    } catch (e) {
      
      setState(() {
        outputt = "Error loading image or getting response!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Description'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 175, 136, 243),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Container(
                  height: 200,
                  width: 200,
                  color: const Color.fromARGB(255, 135, 209, 137),
                  child: Image.asset("lib/assests/Vegahelmate.jpg"),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                askgemini();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                  255,
                  175,
                  136,
                  243,
                ), // button color
                foregroundColor: const Color.fromARGB(
                  255,
                  0,
                  0,
                  0,
                ), // text color
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // rounded corners
                ),
                elevation: 8, // shadow depth
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ),
              ),
              child: Text("Ask Gemini to Give Desc"),
            ),

            if (outputt.isNotEmpty)
              Card(
                color: const Color.fromARGB(255, 232, 222, 248),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    outputt,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 63, 62, 62),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
