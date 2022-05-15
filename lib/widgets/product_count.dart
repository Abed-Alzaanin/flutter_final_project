import 'package:flutter/material.dart';

class ProductCount extends StatelessWidget {
  final IconData icon;
  void Function() count;

  ProductCount({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: count,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        color: Color(0xFFFF9F83),
        elevation: 0,
      ),
    );
  }
}