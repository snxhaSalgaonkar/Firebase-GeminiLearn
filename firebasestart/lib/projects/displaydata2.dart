import 'package:firebasestart/projects/findex.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class LostItemsScreen2 extends StatefulWidget {
  const LostItemsScreen2({super.key});

  @override
  State<LostItemsScreen2> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen2> {
  List<LostItem> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLostItems();
  }

  Future<void> fetchLostItems() async {
    setState(() => isLoading = true);
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Findex')
            .doc('LostItem')
            .collection('items')
            .get();
    items =
        snapshot.docs.map((doc) {
          return LostItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

    setState(() => isLoading = false);
  }

  Future<void> deleteItemFromFirestore(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Findex')
          .doc('LostItem')
          .collection('items')
          .doc(id)
          .delete();

      setState(() {
        items.removeWhere((item) => item.id == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $error')));
    }
  }

  void confirmDelete(LostItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Item'),
            content: const Text('Are you sure you want to delete this item?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  deleteItemFromFirestore(item.id);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost Items"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              fetchLostItems();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('List refreshed')));
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectItemPage()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
              ? const Center(child: Text("No items found."))
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                    child: Container(
                      key: ValueKey(item.id),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
                              confirmDelete(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
