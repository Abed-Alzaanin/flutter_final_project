import 'dart:ffi';

import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: (){Navigator.pushNamed(context, '/search_screen');},
            child: Icon(
              Icons.search,
              color: Colors.deepOrange,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 200,
            child: TextField(
              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                hintText: 'What would you like to buy',
                hintStyle: TextStyle(fontSize: 14),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}