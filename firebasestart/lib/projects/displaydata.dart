import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//class of LostItem
class LostItem {
  final String id;
  final String itemtype;
  final String falseQues;
  final String desc;
  final bool falseQuesAns;

  LostItem({
    required this.id,
    required this.itemtype,
    required this.falseQues,
    required this.desc,
    required this.falseQuesAns,
  });
  factory LostItem.fromMap(Map<String, dynamic> data, String id) {
    return LostItem(
      id: id,
      itemtype: data['Itemtype'] ?? '',
      falseQues: data['falseQues'] ?? '',
      desc: data['desc'] ?? '',
      falseQuesAns: data['falsequesans'] ?? false,
    );
  }
}

class LostItemsScreen extends StatelessWidget {
  const LostItemsScreen({super.key});

  //get lost item
  Future<List<LostItem>> getLostItems() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Findex')
            .doc('LostItem')
            .collection('items')
            .get();

    return snapshot.docs
        .map(
          (doc) => LostItem.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  //delete item
  Future<void> deleteItemFromFirestore(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Findex')
          .doc('LostItem')
          .collection('items')
          .doc(id) // use document ID here
          .delete();

      print("Item deleted successfully");
    } catch (error) {
      print("Delete failed: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lost Items")),
      body: FutureBuilder<List<LostItem>>(
        future: getLostItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text("No items found."));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(child: Text("${index + 1}")),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${item.itemtype}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Desc: ${item.desc}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "False Ques: ${item.falseQues}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Answer: ${item.falseQuesAns}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        print("Pressed on Delete icon of ${item.id} ");
                        deleteItemFromFirestore(item.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
