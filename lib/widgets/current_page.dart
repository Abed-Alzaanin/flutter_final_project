import 'package:flutter/material.dart';

class CurrentPage extends StatelessWidget {

  bool selected;

  CurrentPage({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 4,
      decoration: BoxDecoration(
          color: selected ? Colors.deepOrange : Color(0xFFDDDDDD),
          borderRadius: BorderRadius.circular(2)),
    );
  }
  
}

