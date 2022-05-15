import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/favorite.dart';
import 'package:shoping_online/screens/user/product_detials_screen.dart';
import 'package:shoping_online/widgets/no_data.dart';

import '../../models/product.dart';

class ContentScreen extends StatefulWidget {
  final Stream<QuerySnapshot> content;

  ContentScreen(this.content);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  bool? state;
  bool isAdded = false;
  List<String> favorites = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.content,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GridView.builder(
                  itemCount: documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 100 / 115),
                  itemBuilder: (context, index) {
                    favoriteIds();
                    return GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(getProduct(documents[index])),));},
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 115,
                              child: Image.network(
                                documents[index].get('image'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              documents[index].get('name'),
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Color: ${documents[index].get('color')}, Size: ${documents[index].get('size')}',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text('Rate'),
                                        Spacer(),
                                        Text(
                                          documents[index]
                                                  .get('price')
                                                  .toString() +
                                              '\$',
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return NoData();
            }
          }),
    );
  }

  bool checkFavorite(DocumentSnapshot item) => favorites.contains(item.id);

  Future<void> favoriteProses(List<String> list, DocumentSnapshot item) async {
    if (list.contains(item.id)) {
      await deleteFavorite(item.id);
    } else {
      await addFavorite(item);
    }
  }

  Future<void> favoriteIds() async {
    List<String> idss = await FirebaseFirestoreController().favoriteIds();
    setState(() {
      favorites = idss;
    });
  }

  Future<void> addFavorite(DocumentSnapshot snapshot) async {
    await FirebaseFirestoreController().addFavorite(favorite: getFavoriteDate(snapshot));
  }

  Future<void> deleteFavorite(String id) async {
    String path = await FirebaseFirestoreController().getFavoriteID(id);
    await FirebaseFirestoreController().deleteFavorite(path: path);
  }

  Favorite getFavoriteDate(DocumentSnapshot snapshot) {
    Favorite favorite = Favorite();
    favorite.productId = snapshot.id;
    favorite.userId = FirebaseAuth.instance.currentUser!.uid;
    return favorite;
  }
  Product getProduct(DocumentSnapshot snapshot){
    Product product = Product();
    product.image = snapshot.get('image');
    product.name = snapshot.get('name');
    product.price = snapshot.get('price');
    product.description = snapshot.get('description');
    product.quantity = snapshot.get('quantity');
    return product;
  }
}
