import 'package:flutter/material.dart';

class ProductColor extends StatelessWidget {
  final Color color;
  bool isCheck=false;

  ProductColor({required this.color,this.isCheck=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: color,
              ),
           Visibility(
                  visible: isCheck==true,
                  child: Padding(
                    padding:  EdgeInsets.only(
                      bottom: 3, left: 0,right: 2),
                    child: Icon(Icons.check,size: 25,color: Colors.white,),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}