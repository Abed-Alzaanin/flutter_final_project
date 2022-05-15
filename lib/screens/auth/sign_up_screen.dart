import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/user.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/button.dart';
import 'package:shoping_online/widgets/edit_text.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with Helpers{
  late TapGestureRecognizer _signIn;
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _confirmPassword;
  late TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _signIn = TapGestureRecognizer()..onTap = GoToSignIn;
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _confirmPassword = TextEditingController();
  }

  void GoToSignIn() => Navigator.pushNamed(context, '/sign_in_screen');

  @override
  void dispose() {
    _signIn.dispose();
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _confirmPassword.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100,),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Create account to continue.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditText(
                    controller: _name,
                    hint: 'Full name',
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: 15,
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
                  SizedBox(
                    height: 15,
                  ),
                  EditText(
                    password: true,
                    controller: _confirmPassword,
                    hint: 'Confirm password',
                    icon: Icons.lock,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Button(
                    onPressed: () {
                      signUp();
                    },
                    color: Colors.deepOrange,
                    value: 'Sign Up',
                    colorValue: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 245,),
              SizedBox(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Have an account ! ',
                      style:
                      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            recognizer: _signIn,
                            text: ' Sign in',
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool checkData(){
    bool state = false;
    List inputs = [_email, _password, _name, _confirmPassword];
    for(var input in inputs){
      if(input.text.isEmpty){
        showSnackBar(context: context, content: 'One or more inputs is empty', state: false);
        state = false;
        break;
      }else{
        state = true;
      }
    }

    if(state == false) return state;

    if(_password.text.toString() == _confirmPassword.text.toString()){
      state = true;
    }else{
      showSnackBar(context: context, content: 'Confirm password is failed', state: false);
      state = false;
    }
    return state;
  }

  Future<void> signUp() async{
    if(checkData()){
      await createAccountProces();
    }
  }

  Future<void> createAccountProces() async{
    bool state = await FirebaseAuthController().createAccount(context: context, email: _email.text.toString(), password: _password.text.toString());
    bool nameState = await FirebaseFirestoreController().addUser(user);
    if(state && nameState){
      Navigator.pushReplacementNamed(context, '/sign_in_screen');
    }
  }

  Users get user{
    Users user = Users();
    user.name = _name.text.toString();
    user.email = _email.text.toString();
    user.image = 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
    return user;
  }

}
