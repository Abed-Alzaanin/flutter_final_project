import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/preferences/app_preferences.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/button.dart';
import 'package:shoping_online/widgets/edit_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with Helpers {
  late TapGestureRecognizer _signUp;
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _signUp = TapGestureRecognizer()..onTap = GoToSignUp;
    _email = TextEditingController();
    _password = TextEditingController();
  }

  void GoToSignUp() => Navigator.pushNamed(context, '/sign_up_screen');

  @override
  void dispose() {
    _signUp.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 100,),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Login with account to continue.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              EditText(
                controller: _email,
                hint: 'Email',
                icon: Icons.email,
              ),
              SizedBox(
                height: 15,
              ),
              EditText(
                password: true,
                controller: _password,
                hint: 'Password',
                icon: Icons.lock,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_password');
                },
                child: Text(
                  'Forget password',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Button(
                onPressed: () {
                  signIn();
                },
                color: Colors.deepOrange,
                value: 'Sign in',
                colorValue: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                'or',
                style: TextStyle(color: Colors.grey),
              )),
              SizedBox(
                height: 20,
              ),
              Button(
                onPressed: () {
                  Navigator.pushNamed(context, '/orders_screen');
                },
                color: Color(0xFFABD5FF),
                value: 'Continue with Facebook',
                colorValue: Color(0xFF9E9E9E),
                icon: Image.asset(
                  'images/facebook.png',
                  width: 22,
                  height: 22,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Button(
                onPressed: () {},
                color: Color(0xFFFFB0AB),
                value: 'Continue with Google',
                colorValue: Color(0xFF9E9E9E),
                icon: Image.asset(
                  'images/google.png',
                  width: 22,
                  height: 22,
                ),
              ),
              SizedBox(height: 200,),
              SizedBox(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Dont have an account ? ',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            recognizer: _signUp,
                            text: ' Sign up',
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkData(){
    bool state = false;
    List inputs = [_email, _password];
    for(var input in inputs){
      if(input.text.isEmpty){
        showSnackBar(context: context, content: 'One or more inputs is empty', state: false);
        state = false;
        break;
      }else{
        state = true;
      }
    }

    return state;
  }

  Future<void> signIn() async{
    if(checkData()){
      await signInProces();
    }
  }

  Future<void> signInProces() async{
    bool state = await FirebaseAuthController().signIn(context: context, email: _email.text.toString(), password: _password.text.toString());
    if(state){
      AppPreferences().setPassword(_password.text.toString());
      String userType = await FirebaseFirestoreController().getUserType(_email.text.toString());
      print(userType);
      if(userType == '1'){
        Navigator.pushReplacementNamed(context, '/admin_main_screen');
      }else{
        Navigator.pushReplacementNamed(context, '/user_main_screen');
      }
    }
  }

}
