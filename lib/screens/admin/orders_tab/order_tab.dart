import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../firebase/firebase_firestore.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/no_data.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({Key? key}) : super(key: key);

  @override
  _CompletedOrdersScreenState createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestoreController().readOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(documents[index].get('userImage'))),
                  title: Text(documents[index].get('username')),
                  subtitle: const Text('total'),
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
}
