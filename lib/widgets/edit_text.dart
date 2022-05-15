import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  String hint;
  IconData? icon;
  TextEditingController? controller;
  bool? password = false;
  bool? enabeled = true;

  EditText({this.password, required this.hint, this.icon, this.controller, this.enabeled});

  @override
  Widget build(BuildContext context) {
    return TextField(
      // obscureText: if(password != null){true},
      enabled: enabeled,
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        // hintText:  hint,
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
        // hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(
          icon != null ? icon : null,
          color: Colors.deepOrange,
        ),
        suffixIcon: Visibility(visible: false, maintainSize: true,
            maintainAnimation: true,
            maintainState: true, child: GestureDetector(onTap: (){}, child: Icon(Icons.remove_red_eye, color: Colors.deepOrange,)))
      ),
    );
  }
}
