import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Color color;
  String value;
  Color colorValue;
  Image? icon;
  void Function() onPressed;

  Button({required this.color, required this.value, required this.colorValue, required this.onPressed,  this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: ch(),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
  Widget ch(){
    if(icon != null){
      return Row(
          children: [
            SizedBox(width: 40,),
            icon!,
            SizedBox(width: 20,),
            Center(child: Text(value, style: TextStyle(color: colorValue),),),
          ]
      );
    }else{
      return Text(value, style: TextStyle(color: colorValue),);
    }
  }
}

