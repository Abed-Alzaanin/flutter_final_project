import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/preferences/app_preferences.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/edit_text.dart';

class ChangePasswordScreen extends StatefulWidget {

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> with Helpers{
  late TextEditingController _currentPassword;
  late TextEditingController _newPassword;
  late TextEditingController _confirmPassword;
  late User _user;

  @override
  void initState() {
    _confirmPassword = TextEditingController();
    _newPassword = TextEditingController();
    _currentPassword = TextEditingController();
    _user = FirebaseAuthController().user;
    super.initState();
  }

  @override
  void dispose() {
    _confirmPassword.dispose();
    _newPassword.dispose();
    _currentPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Change password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              updatePassword();
            },
            icon: Icon(
              Icons.check,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            EditText(hint: 'Current password', icon: Icons.lock_outline, controller: _currentPassword, password: true,),
            SizedBox(
              height: 20,
            ),
            EditText(hint: 'New password', icon: Icons.lock_outline, controller: _newPassword, password: true,),
            SizedBox(
              height: 20,
            ),
            EditText(hint: 'Confirm password', icon: Icons.lock_outline, controller: _confirmPassword, password: true,),
          ],
        ),
      ),
    );
  }

  Future<void> updatePassword() async{
    if(checkData()){
      updatePasswordProsses();
    }
  }

  Future<void> updatePasswordProsses() async{
    bool state = await FirebaseAuthController().updatePassword(context, _newPassword.text.toString());
    if(state){
      showSnackBar(
          context: context,
          content: 'Changed successfully',
          state: true);
      Navigator.pop(context);
    }
  }

  bool checkData() {
    bool state = false;
    List inputs = [_newPassword, _confirmPassword, _currentPassword];
    for (var input in inputs) {
      if (input.text.isEmpty) {
        showSnackBar(
            context: context,
            content: 'One or more inputs is empty',
            state: false);
        state = false;
        break;
      } else {
        state = true;
      }
    }

    if(state == false) return state;

    if(_newPassword.text.toString() == _confirmPassword.text.toString()){
      state = true;
    }else{
      showSnackBar(context: context, content: 'Confirm password is failed', state: false);
      state = false;
    }

    if(state == false) return state;

    if(_currentPassword.text.toString() == AppPreferences().getPassword()){
      state = true;
    }else{
      showSnackBar(context: context, content: 'Current password is wrong', state: false);
      state = false;
    }

    return state;
  }

}
