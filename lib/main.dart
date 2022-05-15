import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoping_online/preferences/app_preferences.dart';
import 'package:shoping_online/screens/admin/main_admin_screen.dart';
import 'package:shoping_online/screens/admin/orders_tab/product_tab.dart';
import 'package:shoping_online/screens/admin/orders_tab/category_tab.dart';
import 'package:shoping_online/screens/admin/profile_screen.dart';
import 'package:shoping_online/screens/auth/change_password.dart';
import 'package:shoping_online/screens/user/bottom_navigation/cart_screen.dart';
import 'package:shoping_online/screens/auth/forgot_password.dart';
import 'package:shoping_online/screens/user/bottom_navigation/profile_screen.dart';
import 'package:shoping_online/screens/user/user_main_screen.dart';
import 'package:shoping_online/screens/launch_screen.dart';
import 'package:shoping_online/screens/out_boarding_screen.dart';
import 'package:shoping_online/screens/auth/sign_in_screen.dart';
import 'package:shoping_online/screens/auth/sign_up_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences().initPreferences();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/launch_screen',
      routes: {
        '/launch_screen': (context) => LaunchScreen(),
        '/out_boarding_screen': (context) => OutBoardingScreen(),
        '/sign_in_screen': (context) => SignInScreen(),
        '/sign_up_screen': (context) => SignUpScreen(),
        '/user_main_screen': (context) => UserMainScreen(),
        '/change_password_screen': (context) => ChangePasswordScreen(),
        '/forgot_password': (context) => ForgotPassword(),
        '/orders_screen': (context) => MainAdminScreen(),
        '/products_screen': (context) => ProductsScreen(),
        '/categories_screen': (context) => CategoryTab(),
        '/admin_main_screen': (context) => MainAdminScreen(),
        '/admin_profile_screen': (context) => AdminProfileScreen(),
        '/cart_screen': (context) => CartScreen(),
        '/profile_screen': (context) => ProfileScreen(),
      },
    );
  }
}
