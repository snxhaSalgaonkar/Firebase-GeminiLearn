import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class TextToListScreen extends StatefulWidget {
  const TextToListScreen({super.key});

  @override
  State<TextToListScreen> createState() => _TextToListScreenState();
}

class _TextToListScreenState extends State<TextToListScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic> mapp = {};
  String _response = '';
  String get response => _response;
  bool _isLoading = false;
  String ques = '';

  void _addItem(String text, String resp) {
    if (text.trim().isEmpty) return;
    setState(() {
      mapp.addAll({text: resp});
    });
  }

  void adddata(String ques, String ans) async {
    if (ques == '' || ans == '') {
      print("************#########***************");
      print('No data found');
    } else {
      FirebaseFirestore.instance
          .collection("Gemini")
          .doc()
          .set({"Ques": ques, "Answer": ans})
          .then((value) {
            print("************");
            print('data inserted');
          });
    }
  }

  void clear(TextEditingController controller) {
    {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gemini API"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask Gemini",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18.0,
                  horizontal: 20.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true; // Show loading spinner
              });

              //to take a new response
              setState(() {
                _response = '';
                ques =
                    _controller.text.toString() +
                    ". Give answer in maximun 4 Points";
              });

              Gemini.instance
                  .promptStream(parts: [Part.text(ques)])
                  .listen(
                    (value) {
                      _response += value?.output.toString() ?? '';
                      print("*****" + response);
                    },
                    onDone: () {
                      setState(() {
                        _isLoading = false;
                      });
                      print("*****************" + response);
                      print("*****************#######" + _response);
                      _addItem(ques, response);
                      adddata(ques, response);
                      clear(_controller);
                    },
                  );
            },
            child: Text('ASK GEMINI'),
          ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator() // Show spinner while loading
              : Expanded(
                child: ListView.builder(
                  itemCount: mapp.length,
                  itemBuilder: (context, index) {
                    String key = mapp.keys.elementAt(index);
                    String value = mapp.values.elementAt(index);
                    return ListTile(title: Text(key), subtitle: Text(value));
                  },
                ),
              ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
