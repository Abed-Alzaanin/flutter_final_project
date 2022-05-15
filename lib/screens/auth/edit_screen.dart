import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/firebase/firebase_storage.dart';
import 'package:shoping_online/models/user.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/lite_edit.dart';

class EditScreen extends StatefulWidget {
  late Users user;

  EditScreen({required this.user});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> with Helpers {
  XFile? pickedImage;
  XFile? pickedImage2;
  ImagePicker imagePicker = ImagePicker();
  late String selectedImage;
  DateTime currentDate = DateTime.now();
  bool editPersonal = true;
  bool editCom = true;
  late String image;
  late User _user;
  late Users _users;
  late TextEditingController _email;
  late TextEditingController _name;
  late TextEditingController _gender;
  late TextEditingController _phone;
  late TextEditingController _birthday;

  @override
  void initState() {
    selectedImage = '';
    _user = FirebaseAuthController().user;
    _users = Users();
    _email = TextEditingController(text: _user.email ?? '');
    _name = TextEditingController(text: widget.user.name);
    _gender = TextEditingController(text: widget.user.gender);
    _phone = TextEditingController(text: _user.phoneNumber ?? '');
    _birthday = TextEditingController(text: widget.user.birthday);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _phone.dispose();
    _birthday.dispose();
    _gender.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Edit profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: pickedImage != null ?Image.file(File(pickedImage!.path), fit: BoxFit.cover,) : Image.network(widget.user.image, fit: BoxFit.cover,),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          color: Colors.black.withOpacity(0.50),
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                widget.user.email,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Personal information',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                if (editPersonal == false) {
                                  updatePersonalInfo();
                                }
                                editPersonal = !editPersonal;
                              });
                            },
                            icon: editPersonal
                                ? Icon(
                                    Icons.edit_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.check,
                                    color: Colors.deepOrange,
                                    size: 20,
                                  ),
                          ),
                        ],
                      ),
                      ListEdit(
                        onTap: () {},
                        controller: _name,
                        icon: Icons.person_outline,
                        title: 'Full name',
                        enabled: !editPersonal,
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListEdit(
                        onTap: () {
                          if (editPersonal == false) {
                            showBottomSheet();
                          }
                        },
                        controller: _gender,
                        icon: Icons.female_outlined,
                        title: 'Gender',
                        enabled: false,
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListEdit(
                        onTap: () {
                          if (editPersonal == false) {
                            _selectDate(context);
                          }
                        },
                        controller: _birthday,
                        icon: Icons.broken_image_rounded,
                        title: 'Birthday',
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Communication information',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                if (editCom == false) {
                                  updateCommunicationInfo();
                                }
                                editCom = !editCom;
                              });
                            },
                            icon: editCom
                                ? Icon(
                                    Icons.edit_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.check,
                                    color: Colors.deepOrange,
                                    size: 20,
                                  ),
                          ),
                        ],
                      ),
                      ListEdit(
                        onTap: () {},
                        controller: _phone,
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        enabled: !editCom,
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListEdit(
                        onTap: () {},
                        controller: _email,
                        icon: Icons.email_outlined,
                        title: 'Email',
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool checkPersonalData() {
    bool state = false;
    List inputs = [_name, _gender, _birthday];
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
    return state;
  }

  bool checkCommunicationData() {
    bool state = false;
    List inputs = [_email];
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
    return state;
  }

  Users get getUser {
    Users user = Users();
    user.name = _name.text.toString();
    user.gender = _gender.text.toString();
    user.birthday = _birthday.text.toString();
    user.email = _email.text.toString();
    user.image = widget.user.image;
    return user;
  }

  Future<void> updatePersonalInfoProsses() async {
    if (checkPersonalData()) {
      showSnackBar(
        context: context,
        content: 'Updating...',
        state: null,
      );
      bool user = await FirebaseFirestoreController()
          .updateUser(path: widget.user.path, user: getUser);
      if (user) {
        showSnackBar(
          context: context,
          content: 'Your personal information was updated successfully',
          state: true,
        );
      }
    }
  }

  Future<void> updateCommunicationInfoProsses() async {
    bool email = await FirebaseAuthController()
        .updateEmail(context, _email.text.toString());
    if (email) {
      showSnackBar(
        context: context,
        content: 'Your Communication Information was updated successfully',
        state: true,
      );
    }
  }

  Future<void> updatePersonalInfo() async {
    if (checkPersonalData()) {
      await updatePersonalInfoProsses();
    }
  }

  Future<void> updateCommunicationInfo() async {
    if (checkCommunicationData()) {
      await updateCommunicationInfoProsses();
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                  title: Text('Male'),
                  value: 'Male',
                  groupValue: _gender.text.toString(),
                  onChanged: (String? value) {
                    if (value != null)
                      setState(() {
                        _gender.text = value;
                      });

                    Navigator.pop(context);
                  }),
              RadioListTile(
                  title: Text('Female'),
                  value: 'Female',
                  groupValue: _gender.text.toString(),
                  onChanged: (String? value) {
                    if (value != null)
                      setState(() {
                        _gender.text = value;
                      });

                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        _birthday.text = pickedDate.toString().split(' ')[0];
      });
  }

  Future<void> pickImage() async {
    pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      showDialog(
        context: context,
        builder: (context) =>
            FutureProgressDialog(uploadImage(), message: Text('Loading...')),
      );
      selectedImage = await uploadImage();
      bool state = await FirebaseFirestoreController().updateUserImage(path: widget.user.path, image: selectedImage);
      if(state){
        setState(() {
          pickedImage2 = pickedImage;
        });
      }
    }
  }

  Future<String> uploadImage() async{
    return await FirebaseStorageController()
        .uploadImage(file: File(pickedImage!.path), name: _user.uid);
  }
}
