import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/order.dart';
import 'package:shoping_online/models/orderItem.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/button.dart';
import 'package:shoping_online/widgets/no_data.dart';
import 'package:shoping_online/widgets/search_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with Helpers {
  int quantity = 0;
  double total = 0.0;
  String userName = '';
  String userImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Cart',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestoreController().readCart(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          total = 0.0;
                          for(DocumentSnapshot doc in documents){
                              total += double.parse(doc.get('total').toString());
                          }
                          quantity = documents[index].get('quantity');
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)),
                                        width: 70,
                                        height: 70,
                                        child: Image.network(
                                          documents[index].get('image'),
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          documents[index].get('name'),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'Color: ${documents[index].get('color')} - Size: ${documents[index].get('size')}',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          (documents[index].get('price') * quantity).toString() + '\$',
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))
                                        ) ,child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text('x ${documents[index].get('quantity')}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                                        )),
                                        SizedBox(height: 45,),
                                        Container(decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15))
                                        ) ,child: Padding(
                                          padding: EdgeInsets.all(3.0),
                                          child: GestureDetector(onTap: (){deleteCart(documents[index].id);} ,child: Icon(Icons.delete_outline, color: Colors.grey, size: 22,)),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(15),
                    child: Button(color: Colors.deepOrange, value: 'Buy Now', colorValue: Colors.white, onPressed: () { addOrder(getOrderData()); },),
                  )
                ],
              );
            }else{
              return NoData();
            }
          }
        ));
  }
  Future<void> deleteCart(String path) async{
    await FirebaseFirestoreController().deleteCart(path: path);
  }

  Future<void> addOrder(Order order) async {
    bool state = await FirebaseFirestoreController().addOrder(order: order);
    print(order.toString());
    if(state){
      showSnackBar(
          context: context,
          content: 'Send Order Successfully',
          state: true);
    }
  }

  Future<void> getUser() async{
    List<String> user = await FirebaseFirestoreController().getUser();
    userImage = user[1];
    userName = user[0];
  }

  Order getOrderData(){
    Order order = Order();
    order.email = FirebaseAuthController().user.email.toString();
    order.total = total;
    order.userImage = userImage;
    order.username = userName;
    return order;
  }
}
