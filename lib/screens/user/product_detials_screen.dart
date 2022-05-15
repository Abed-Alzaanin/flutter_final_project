import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/cart.dart';
import 'package:shoping_online/models/color.dart';
import 'package:shoping_online/models/product.dart';
import 'package:shoping_online/models/size.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/button.dart';
import 'package:shoping_online/widgets/product_color.dart';
import 'package:shoping_online/widgets/product_count.dart';
import 'package:shoping_online/widgets/product_size.dart';

class DetailsScreen extends StatefulWidget {
  Product? productDetails;

  DetailsScreen(this.productDetails);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with Helpers {
  String size = '';
  String color = '';
  String userName = '';
  String userImage = '';
  int quantity = 1;

  List<Sizee> productSize = <Sizee>[
    Sizee(value: 'S', color: Colors.grey.shade200),
    Sizee(value: 'M', color: Colors.grey.shade200),
    Sizee(value: 'L', color: Colors.grey.shade200),
    Sizee(value: 'XL', color: Colors.grey.shade200),
  ];

  List<Colorr> productColor = <Colorr>[
    Colorr(value: 'Red', color: Colors.red, stats: false),
    Colorr(value: 'Green', color: Colors.green, stats: false),
    Colorr(value: 'Blue', color: Colors.blue, stats: false),
    Colorr(value: 'Pink', color: Colors.pink, stats: false),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: 450,
            child: Image.network(
              widget.productDetails!.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(
                    20,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productDetails!.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Rate')
                          ],
                        ),
                        Spacer(),
                        Text(
                          (widget.productDetails!.price * quantity).toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Size: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 40,
                          width: 175,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: productSize.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      size = productSize[index].value;
                                      print(size);
                                      productSize[index].color =
                                          Colors.deepOrange;
                                      for (Sizee ps in productSize) {
                                        if (ps == productSize[index]) {
                                          continue;
                                        }
                                        ps.color = Colors.grey.shade200;
                                      }
                                    });
                                  },
                                  child: ProductSize(
                                      title: productSize[index].value,
                                      color: productSize[index].color));
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Color: ',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 40,
                          width: 175,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: productColor.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      color = productColor[index].value;
                                      print(color);
                                      productColor[index].stats = true;
                                      for (Colorr c in productColor) {
                                        if (c == productColor[index]) {
                                          continue;
                                        }
                                        c.stats = false;
                                      }
                                    });
                                  },
                                  child: ProductColor(
                                      isCheck: productColor[index].stats,
                                      color: productColor[index].color));
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Quantity: ',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            ProductCount(
                              icon: Icons.add, count: () {
                              if (quantity < widget.productDetails!.quantity) {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                            ),
                            SizedBox(width: 10),
                            Text(quantity.toString()),
                            SizedBox(width: 10),
                            ProductCount(
                              icon: Icons.minimize, count: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.productDetails!.description,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Button(
                      color: Colors.deepOrange,
                      value: 'Add To Cart',
                      colorValue: Colors.white,
                      onPressed: () {
                        addToCart();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUser() async{
    List<String>? userData = await FirebaseFirestoreController().getUser();
    userName = userData[0];
    userImage = userData[1];
    print(userName);
    print(userImage);
  }

  Future<void> addToCartProcess() async{
    bool stats = await FirebaseFirestoreController().addToCart(cart: cart);
    if(stats){
      Navigator.pop(context);
    }
  }

  bool checkData(){
    if(color != '' && size != ''){
      return true;
    }else{
      showSnackBar(context: context, content: 'One or more input are empty', state: false);
      return false;
    }
  }

  Future<void> addToCart() async{
    if(checkData()){
      await addToCartProcess();
    }
  }


  Cart get cart{
    Cart cart = Cart();
    cart.email = FirebaseAuthController().user.email.toString();
    cart.quantity = quantity;
    cart.color = color;
    cart.size = size;
    cart.name = widget.productDetails!.name;
    cart.price = widget.productDetails!.price;
    cart.total = widget.productDetails!.price * quantity;
    cart.image = widget.productDetails!.image;
    cart.userImage = userImage;
    cart.username = userName;
    return cart;
  }
}

