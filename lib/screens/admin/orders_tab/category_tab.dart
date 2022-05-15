import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/category.dart';
import 'package:shoping_online/screens/admin/category_controller_screen.dart';
import 'package:shoping_online/widgets/loading.dart';
import 'package:shoping_online/widgets/no_data.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({Key? key}) : super(key: key);

  @override
  _CategoryTabState createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryController(null),
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestoreController().readCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryController(getCategory(documents[index])),));},
                  leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(documents[index].get('image'))),
                  title: Text(documents[index].get('name')),
                  subtitle: const Text('0 items'),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            return const NoData();
          }
        },
      ),
    );
  }

  Category getCategory(DocumentSnapshot snapshot){
    Category category = Category();
    category.image = snapshot.get('image');
    category.name = snapshot.get('name');
    category.path = snapshot.id;
    return category;
  }
}
