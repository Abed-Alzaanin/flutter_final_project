import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shoping_online/utils/helper.dart';

class FirebaseAuthController with Helpers {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> createAccount({required BuildContext context, required String email, required String password}) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await emailValidation(context, credential);
      return true;
    } on FirebaseAuthException catch (e) {
      _controlErrorCodes(context, e);
    } catch (e) {
      showSnackBar(
          context: context, content: 'Something was wrong', state: false);
    }
    return false;
  }

  User get user => _firebaseAuth.currentUser!;

  Future<bool> signIn({required BuildContext context, required String email, required String password}) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return await emailValidation(context, credential);
    } on FirebaseAuthException catch (e) {
      _controlErrorCodes(context, e);
    } catch (e) {
      showSnackBar(
          context: context, content: 'Something was wrong', state: false);
    }
    return false;
  }

  Future<bool> emailValidation(BuildContext context, UserCredential credential) async {
    if (!credential.user!.emailVerified) {
      await credential.user!.sendEmailVerification();
      await _firebaseAuth.signOut();
      showSnackBar(
          context: context, content: 'Check your email and confirm it');
      return false;
    }
    return true;
  }

  Future<bool> updateUserName(String newName) async {
    String currentName = _firebaseAuth.currentUser!.displayName ?? '';
    if (currentName != newName) {
      await _firebaseAuth.currentUser!
          .updateDisplayName(newName)
          .then((value) => true)
          .catchError((error) {print('error: $error'); return false;});
    }
    return true;
  }

  Future<bool> updateEmail(BuildContext context, String newEmail) async {
    String currentEmail = _firebaseAuth.currentUser!.email!;
    if (currentEmail != newEmail) {
      try{
        await _firebaseAuth.currentUser!
            .verifyBeforeUpdateEmail(newEmail)
            .then((value) => true)
            .catchError((error) => false);
        signOut();
        return true;
      }on FirebaseAuthException catch(e){
        _controlErrorCodes(context, e);
      }catch(e){
        showSnackBar(
            context: context, content: 'Something was wrong', state: false);
      }
    }
    return false;
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  Future<bool> updatePassword(BuildContext context, String newPassword) async{
    try{
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
      return true;
    }on FirebaseAuthException catch(e){
      _controlErrorCodes(context, e);
    }catch(e){
      showSnackBar(
          context: context, content: 'Something was wrong', state: false);
    }
    return false;
  }

  Future<bool> forgotPassword(BuildContext context, {required String email}) async{
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    }on FirebaseAuthException catch(e){
      _controlErrorCodes(context, e);
    }catch(e){
      showSnackBar(context: context, content: 'Something was wrong', state: false);
    }
    return false;
  }

  void _controlErrorCodes(BuildContext context, FirebaseAuthException authException) {
    showSnackBar(context: context, content: authException.code, state: false);
    switch (authException.code) {
      case 'email-already-in-use':
        break;

      case 'invalid-email':
        break;

      case 'operation-not-allowed':
        break;

      case 'weak-password':
        break;

      case 'user-not-found':
        break;

      case 'requires-recent-login':
        break;
    }
  }
}
