import 'package:flutter/material.dart';
import 'package:shoping_online/widgets/current_page.dart';

class OutBoarding extends StatelessWidget {
  String image;
  String title;
  String subTitle;

  OutBoarding({
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('skip'),
          Image.asset(
            image,
            width: 400,
            height: 200,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            subTitle,
            style: TextStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
