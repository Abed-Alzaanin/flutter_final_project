import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/product.dart';
import 'package:shoping_online/screens/user/category_detials_screen.dart';
import 'package:shoping_online/widgets/button.dart';
import 'package:shoping_online/widgets/current_page.dart';
import 'package:shoping_online/widgets/lite_edit.dart';
import 'package:shoping_online/widgets/no_data.dart';
import 'package:shoping_online/widgets/search_bar.dart';

import '../product_detials_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  bool selected = false;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: SearchBar(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                        children: [
                          Image.asset(
                            'images/dd.jpg',
                            fit: BoxFit.cover,
                            height: double.infinity,
                          ),
                          Image.network(
                            'https://images.pexels.com/photos/291762/pexels-photo-291762.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                            fit: BoxFit.cover,
                            height: double.infinity,
                          ),
                          Image.network(
                            'https://images.pexels.com/photos/2292953/pexels-photo-2292953.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                            fit: BoxFit.cover,
                            height: double.infinity,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CurrentPage(selected: _currentPage == 0),
                          SizedBox(width: 10),
                          CurrentPage(selected: _currentPage == 1),
                          SizedBox(width: 10),
                          CurrentPage(selected: _currentPage == 2),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestoreController().readCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: documents.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContentScreen(
                                            FirebaseFirestoreController().readProductByCategory(documents[index].id))));
                              },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  documents[index].get('image'),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.deepOrangeAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return NoData();
                      }
                    }),
              ),
              SizedBox(height: 10),
              SizedBox(
                child: Row(
                  children: [
                    Text(
                      'Discount Product',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContentScreen(
                                    FirebaseFirestoreController().readDiscountProduct())));
                      },
                      child: Text(
                        'See More',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                width: double.infinity,
              ),
              SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestoreController().readDiscountProduct(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: documents.length > 5 ? 5 : documents.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            childAspectRatio: 100 / 70,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(getProduct(documents[index])),));
                              },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Image.network(
                                      documents[index].get('image'),
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(7),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.deepOrange,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                                (documents[index].get('disCount') * (100)).toString() +
                                                  '%',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 50,
                                        color: Colors.white.withOpacity(0.5),
                                        padding: EdgeInsets.only(
                                            left: 15, bottom: 6),
                                        alignment: Alignment.bottomLeft,
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              documents[index].get('name'),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            // SizedBox(height: 5),
                                            Text(
                                              documents[index]
                                                      .get('price')
                                                      .toString() +
                                                  '\$',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                color: Colors.grey,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return NoData();
                      }
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                child: Row(
                  children: [
                    Text(
                      'New Product',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContentScreen(
                                    FirebaseFirestoreController().readNewProduct())));
                      },
                      child: Text(
                        'See More',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                width: double.infinity,
              ),
              SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestoreController().readNewProduct(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: documents.length > 5 ? 5 : documents.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            childAspectRatio: 100 / 70,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(getProduct(documents[index])),));},
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Image.network(
                                      documents[index].get('image'),
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 50,
                                        color: Colors.white.withOpacity(0.50),
                                        padding:
                                            EdgeInsets.only(left: 15, bottom: 6),
                                        alignment: Alignment.bottomLeft,
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              documents[index].get('name'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              documents[index].get('price').toString() + '\$',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                color: Colors.grey.shade200,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return NoData();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
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
