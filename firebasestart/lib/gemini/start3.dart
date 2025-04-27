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

  void _addItem(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      mapp.addAll({text: response});
      //maplist.add({"Question": text, "Answer": response});
    });
    _controller.clear();
    _response = ''; // Clear the TextField
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text to List Example"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              //onSubmitted: _addItem, // Press Enter to add
              decoration: InputDecoration(
                hintText: "Type something and press Enter",
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
                //_response = ''; // Clear old response
              });

              Gemini.instance
                  .promptStream(parts: [Part.text(_controller.text.toString())])
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
                      //_controller.clear();
                      _addItem(_controller.text.toString());
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

          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       _isLoading = true; // Show loading spinner
          //       _response = ''; // Clear old response
          //     });

          //     Gemini.instance
          //         .promptStream(parts: [Part.text(_controller.text.toString())])
          //         .listen(
          //           (value) {
          //             _response += value?.output.toString() ?? '';
          //             print("*****" + response);
          //             // _addItem(_controller.text.toString());
          //           },
          //           onDone: () {
          //             setState(() {
          //               _isLoading = false;
          //             });
          //             print("*****************" + response);
          //             _controller.clear();
          //           },
          //         );
          //   },
          //   child: Text('ASK GEMINI'),
          // ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: mapp.length,
          //     //itemCount: _items.length,
          //     itemBuilder: (context, index) {
          //       String key = mapp.keys.elementAt(index);
          //       String value = mapp.values.elementAt(index);
          //       return ListTile(title: Text(key), subtitle: Text(value));

          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
