import 'package:flutter/material.dart';

mixin Helpers {
  void showSnackBar({required BuildContext context, required String content, bool? state}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(content),
        backgroundColor: states(state),
      ),
    );
  }

  Color states(bool? state){
    if(state != null){
      if(state){
        return Colors.green;
      }else{
        return Colors.red;
      }
    }else{
      return Colors.deepOrange;
    }
  }

}
