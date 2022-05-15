import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  late SharedPreferences _sharedPreferences;

  factory AppPreferences() {
    return _instance;
  }

  AppPreferences._internal();

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setPassword(String password) async{
    await _sharedPreferences.setString('password', password);
  }

  Future<void> setCategoryID(String id) async{
    await _sharedPreferences.setString('categoryID', id);
  }

  String getPassword() {
    return _sharedPreferences.getString('password') ?? '';
  }

  String getCategoryID() {
    return _sharedPreferences.getString('categoryID') ?? '';
  }
}
