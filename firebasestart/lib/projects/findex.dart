import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasestart/projects/displaydata2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SelectItemPage extends StatefulWidget {
  @override
  _SelectItemPageState createState() => _SelectItemPageState();
}

class _SelectItemPageState extends State<SelectItemPage> {
  final List<String> itemList = [
    'Airpods',
    'Water Bottle',
    'Umbrella',
    'Mobile',
    'Laptop',
    'Helmate',
    'Earings',
    'Bracelet',
    'Necklace',
    'Other',
  ];

  String? selectedItem;
  //pick image
  String? _imageUrl;
  File? _imagefile;
  Uint8List? _webImageBytes; // Web only
  http.MultipartFile? _pickedMultipartFile;
  String? imageurl;

  bool _isUploading = false; //to get decs

  String description = '';
  String prompt = 'Describe the image';
  bool isEditing = false;
  TextEditingController descriptionController = TextEditingController();
  bool _saved = false;
  String ques = '';
  bool? quesAns;

  TextEditingController itemcontroller = TextEditingController();
  TextEditingController falseQcontroller = TextEditingController();

  void _showAlertBox(BuildContext context) {
    //if choose other
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('title alert box'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                selectedItem = value;
                itemcontroller.text = value; //saves the value
              });
            },
            // onChanged: (value) => selectedItem = value,
            decoration: InputDecoration(
              labelText: 'Enter custom item',
              border: OutlineInputBorder(),
            ),
          ),

          //content: Text('This is a simple alert dialog.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                print('OK pressed');
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showItemSelectionSheet() {
    //takes the item type and saves into "String? selectedItem"
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(itemList[index]),
              onTap: () {
                setState(() {
                  selectedItem = itemList[index];
                  //customItem = null;
                  itemcontroller.text = selectedItem!; // Reset custom item
                });
                Navigator.pop(context);
                print("Selected item: ${itemList[index]}");

                if (selectedItem == 'Other') {
                  _showAlertBox(context);
                  itemcontroller.clear(); //clear "other"
                }
              },
            );
          },
        );
      },
    );
  }

  void _onSubmit() {
    //summit the item type
    if (itemcontroller != null) {
      print('Selected Item =$selectedItem');
    } else {
      print('Nothing selected');
    }
  }

  void _clear(TextEditingController textcontroller) {
    textcontroller.clear();
    selectedItem = null;
    print('Cleared');
  }

  Future<void> _pickImage() async {
    //1.pick a image
    //2. for web pass uit8list to _webImageBytes
    //3. for !web passs file to _imagefile
    //4. create a PickedMultipartfile for cloudinary

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
        _webImageBytes = bytes; //save data
        _pickedMultipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: pickedFile.name,
        );
      });
    } else {
      final file = File(pickedFile.path);
      setState(() {
        _imagefile = file; //save data
      });
      _pickedMultipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
      );
    }
  }

  Future<void> getDescription(File image) async {
    //get the description and store it into description string

    print("gemini is called");

    final bytes = await image.readAsBytes();
    try {
      _isUploading = true;
      final result = await Gemini.instance.textAndImage(
        text: prompt,
        images: [bytes],
      );
      setState(() {
        description = result?.output ?? 'No description provided';
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        description = 'error: ::: $e';
      });
    }
  }

  Future<void> getDescriptionFromBytes(Uint8List bytes) async {
    //get the description and store it into description string
    print("gemini is called");
    try {
      setState(() {
        _isUploading = true;
      });
      final result = await Gemini.instance.textAndImage(
        text: prompt,
        images: [bytes],
      );
      setState(() {
        description = result?.output ?? 'No description provided'; //data saved
      });
    } catch (e) {
      setState(() {
        description = 'error: ::: $e';
        print(description);
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _falseques() {
    //generate a question answer pair and store it in following
    // String ques = '';
    // bool? quesAns; // Nullable until selected
    TextEditingController questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Generate a false question'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    onChanged: (value) {
                      setState(() {
                        ques = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Select the correct answer:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            quesAns = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              quesAns == true ? Colors.green : null,
                        ),
                        child: Text('True'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            quesAns = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: quesAns == false ? Colors.red : null,
                        ),
                        child: Text('False'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    if (ques.isNotEmpty && quesAns != null) {
                      print('Question: $ques');
                      print('Answer: $quesAns');
                      Navigator.of(context).pop();
                      // You can now use ques and quesAns
                    } else {
                      // Optional: show a warning if fields are incomplete
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please enter a question and select an answer',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    //uploads image to cloundinary
    //stores the url into imageurl string
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

  adddatatoFirebase(
    String itemtype,
    String imageurl,
    String falseQues,
    String Decs,
    bool falseQuesans,
  ) async {
    if (itemtype == '' || imageurl == '' || falseQues == '' || Decs == '') {
      print('enter required Details');
    } else {
      FirebaseFirestore.instance
          .collection('Findex')
          .doc("LostItem")
          .collection('items')
          .doc()
          .set({
            'Itemtype': itemtype,
            'imageurl': imageurl,
            'falseQues': falseQues,
            'desc': Decs,
            'falsequesans': falseQuesans,
          })
          .then((value) {
            print("data inserted");
          });
    }
  }

  void printFuctionOnsubmit() {
    print('******************************');
    print("selected type=");
    print(selectedItem);
    print('imageurl=');
    print(imageurl);
    print('ques');
    print(ques);
    print("description");
    print(description);
    print("quesAns");
    print(quesAns);
  }

  void clearData() {
    selectedItem = null;
    _imageUrl = null;
    _imagefile = null;
    _webImageBytes = null; // Web only
    _pickedMultipartFile = null;
    imageurl = null;

    _isUploading = false; //to get decs

    description = '';
    isEditing = false;
    descriptionController.clear();
    _saved = false;
    ques = '';
    quesAns = null;

    itemcontroller.clear();
    falseQcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select an Item')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //display database
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LostItemsScreen2()),
                  );
                },
                child: Text('Get Database'),
              ),

              //enter the type
              GestureDetector(
                onTap: _showItemSelectionSheet,
                child: AbsorbPointer(
                  child: TextField(
                    controller: itemcontroller,
                    decoration: InputDecoration(
                      labelText: 'Tap to select an item',
                      hintText: selectedItem ?? 'Choose an item',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //button to submit
              //svaed in selecteditem
              //button to clear
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: _onSubmit, child: Text('Submit')),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _clear(itemcontroller);
                    },
                    child: Text('Clear'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              //pickimage
              //save in Imagefile, _weImageBytes
              //display after selecting
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.grey[300],
                  fixedSize: Size(200, 200),
                ),
                child:
                    _imagefile != null || _webImageBytes != null
                        ? ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child:
                                kIsWeb &&
                                        _webImageBytes !=
                                            null //website
                                    ? Image.memory(
                                      _webImageBytes!,
                                      fit: BoxFit.cover,
                                    )
                                    : (!kIsWeb &&
                                            _imagefile !=
                                                null //app
                                        ? Image.file(
                                          _imagefile!,
                                          fit: BoxFit.cover,
                                        )
                                        : Icon(Icons.image, size: 100)),
                          ),
                        )
                        : Text("Upload Image"),
              ),
              SizedBox(height: 20),

              //ask Gemini for Description
              //desc is saved in Description string
              if (_imagefile != null || _webImageBytes != null) ...[
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (kIsWeb) {
                      getDescriptionFromBytes(_webImageBytes!);
                    } else {
                      getDescription(_imagefile!);
                    }
                  },
                  child: Text('Ask Gemini for Desc'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Change Image'),
                ),
              ],
              SizedBox(height: 20),

              //show description
              //able to edit it
              if (_isUploading)
                CircularProgressIndicator()
              else if (description != "" && !isEditing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                          descriptionController.text = description!;
                        });
                      },
                      child: Text('Edit'),
                    ),
                  ],
                )
              else if (isEditing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Edit Description',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          description = descriptionController.text;
                          isEditing = false;
                          print(description);
                          _saved = true; //edited descriotion is saved
                        });
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),

              //generate false question
              SizedBox(height: 20),
              if (_saved)
                ElevatedButton(
                  onPressed: () {
                    _falseques();
                  },
                  child: Text('Generate a false question'),
                ),

              SizedBox(height: 20),
              ques == ''
                  ? Center(
                    child: Text(
                      'No question added yet.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                  : Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question:',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(179, 16, 16, 16),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            ques,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Answer: ${quesAns == true ? "True" : "False"}',
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  quesAns == true
                                      ? Colors.green.shade400
                                      : Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              //submit button to upload image to cloudinary
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: Text('Submit image'),
              ),

              //url
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
                    printFuctionOnsubmit();

                    adddatatoFirebase(
                      selectedItem!,
                      imageurl!,
                      ques,
                      description,
                      quesAns!,
                    );

                    clearData();
                  },
                  child: Text("submit data to firebase"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
