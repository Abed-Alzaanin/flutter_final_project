import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoping_online/models/navgation_bottom.dart';
import 'package:shoping_online/screens/user/bottom_navigation/cart_screen.dart';
import 'package:shoping_online/screens/user/bottom_navigation/home_screen.dart';
import 'package:shoping_online/screens/user/bottom_navigation/profile_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  final List<OnTabNavigation> list = <OnTabNavigation>[
    OnTabNavigation(screen: HomeScreen()),
    OnTabNavigation(screen: CartScreen()),
    OnTabNavigation(screen: ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.deepOrange,
        onTap: (int currentIndex){
          setState(() {
            _currentIndex = currentIndex;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined,), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline,), label: 'Profile'),
        ],
      ),
      body: list[_currentIndex].screen,
    );
  }
}
