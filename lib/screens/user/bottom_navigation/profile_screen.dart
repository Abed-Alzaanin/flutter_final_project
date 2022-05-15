import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/models/user.dart';
import 'package:shoping_online/screens/auth/edit_screen.dart';
import 'package:shoping_online/widgets/loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _language = 'ar';
  late User _user;
  late String name = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuthController().user;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestoreController().readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<DocumentSnapshot> documents = snapshot.data!.docs;
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(documents[0].get('image')),
                      ),
                      title: Text(documents[0].get('name')),
                      subtitle: Text(documents[0].get('email')),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFFFDCD2)),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){Navigator.pushNamed(context, '/favorite_screen');},
                                child: ProfileIcon(
                                  title: 'Favorite',
                                  icon: Icons.favorite,
                                ),
                              ),
                              Spacer(),
                              ProfileIcon(
                                title: 'Following',
                                icon: Icons.person_add,
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: (){Navigator.pushNamed(context, '/cart_screen');},
                                child: ProfileIcon(
                                  title: 'My Order',
                                  icon: Icons.list_alt,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          ProfileSetting(
                            title: 'Edit profile',
                            firstIcon: Icons.person_outline,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(user: getUserData(documents[0]),)));
                            },
                          ),
                          ProfileSetting(
                            title: 'Notification',
                            firstIcon: Icons.notifications_none,
                            onPressed: () {},
                          ),
                          ProfileSetting(
                            title: 'Language',
                            firstIcon: Icons.language,
                            onPressed: () {
                              showBottomSheet();
                            },
                          ),
                          ProfileSetting(
                            title: 'Change password',
                            firstIcon: Icons.lock_outline,
                            onPressed: () {
                              Navigator.pushNamed(context, '/change_password_screen');
                            },
                          ),
                          ProfileSetting(
                            title: 'Contact Us',
                            firstIcon: Icons.contact_support_outlined,
                            onPressed: () {},
                          ),
                          ProfileSetting(
                            title: 'Logout',
                            firstIcon: Icons.logout,
                            onPressed: () {
                              showAlertDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }else{
                return Loading();
              }
            }
          ),
        ),
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) {
        return AlertDialog(
          title: Text('Log out'),
          content: Text(
            'Are you sure you want to logout',
            style: TextStyle(color: Colors.grey),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () {
                signOut();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
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
                  title: Text('Arabic'),
                  value: 'ar',
                  groupValue: _language,
                  onChanged: (String? value) {
                    if (value != null)
                      setState(() {
                        _language = value;
                      });

                    Navigator.pop(context);
                  }),
              RadioListTile(
                  title: Text('English'),
                  value: 'en',
                  groupValue: _language,
                  onChanged: (String? value) {
                    if (value != null)
                      setState(() {
                        _language = value;
                      });

                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> signOut() async {
    await FirebaseAuthController().signOut();
    Navigator.pushReplacementNamed(context, '/sign_in_screen');
  }

  Users getUserData(DocumentSnapshot snapshot){
    Users user = Users();
    user.path = snapshot.id.toString();
    user.name = snapshot.get('name');
    user.birthday = snapshot.get('birthday');
    user.gender = snapshot.get('gender');
    user.email = snapshot.get('email');
    user.image = snapshot.get('image');
    return user;
  }
}

class ProfileSetting extends StatelessWidget {
  final String title;
  final IconData firstIcon;
  void Function() onPressed;

  ProfileSetting({
    required this.title,
    required this.firstIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(
        firstIcon,
        color: Colors.deepOrange,
        size: 25,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 15,
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  ProfileIcon({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.deepOrange,
        ),
        SizedBox(height: 10),
        Text(title),
      ],
    );
  }
}
