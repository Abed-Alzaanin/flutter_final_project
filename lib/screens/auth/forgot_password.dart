import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/button.dart';
import 'package:shoping_online/widgets/edit_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with Helpers {
  late TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Enter your email to reset password',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 50,
            ),
            EditText(
              hint: 'Email',
              icon: Icons.email_outlined,
              controller: _email,
            ),
            SizedBox(
              height: 50,
            ),
            Button(
                color: Colors.deepOrange,
                value: 'Send',
                colorValue: Colors.white,
                onPressed: () {forgotPassword();}),
            SizedBox(
              height: 70,
              child: Center(
                  child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/sign_in_screen');
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> forgotPasswordProssce() async {
    bool state = await FirebaseAuthController()
        .forgotPassword(context, email: _email.text.toString());
    if (state) {
      showSnackBar(
          context: context, content: 'Check your email to reset password');
    }
    Navigator.pushReplacementNamed(context, '/sign_in_screen');
  }

  bool checkData() {
    if (_email.text.isNotEmpty) {
      return true;
    } else {
      showSnackBar(context: context, content: 'Enter your email', state: false);
      return false;
    }
  }

  Future<void> forgotPassword() async {
    if (checkData()) {
      await forgotPasswordProssce();
    }
  }
}
