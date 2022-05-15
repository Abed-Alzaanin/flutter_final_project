import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/product.dart';
import 'package:shoping_online/preferences/app_preferences.dart';
import 'package:shoping_online/screens/admin/product_controller_screen.dart';
import 'package:shoping_online/widgets/loading.dart';
import 'package:shoping_online/widgets/no_data.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with SingleTickerProviderStateMixin {
  String categoryId = '';
  bool addProduct = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Visibility(
        visible: addProduct,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductController(null),
              ),
            );
          },
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.add),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestoreController().readProduct(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ProductController(getProduct(documents[index])),));},
                    leading: CircleAvatar(
                        backgroundImage:
                        NetworkImage(documents[index].get('image'))),
                    title: Text(documents[index].get('name')),
                    subtitle: Text(documents[index].get('quantity').toString() + ' items'),
                    trailing: Text(documents[index].get('price').toString()),
                  );
                },
              );
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return Loading();
            }else {
              return NoData();
            }
          }
      ),
    );
  }

  Product getProduct(DocumentSnapshot snapshot){
    Product product = Product();
    product.image = snapshot.get('image');
    product.name = snapshot.get('name');
    product.price = snapshot.get('price');
    product.color = snapshot.get('color');
    product.size = snapshot.get('size');
    product.quantity = snapshot.get('quantity');
    product.description = snapshot.get('description');
    product.path = snapshot.id;
    return product;
  }
}
