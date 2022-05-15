import 'package:flutter/material.dart';

class ListEdit extends StatelessWidget {
  final IconData icon;
  final String title;
  TextEditingController? controller;
  final bool? enabled;
  void Function() onTap;

  ListEdit({
    required this.icon,
    required this.title,
    this.enabled,
    this.controller,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.deepOrange,
        size: 23,
      ),
      title: TextField(
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          disabledBorder: InputBorder.none,
          hintText: title,
          hintStyle: TextStyle(fontSize: 14),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}