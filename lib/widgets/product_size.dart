import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductSize extends StatelessWidget {
  final String title;
  final Color color;

  ProductSize({required this.title,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color:color,
      ),
    );
  }
}