
class Users {
  String path = '';
  String name = '';
  String gender = '';
  String birthday = '';
  String email = '';
  String image = '';
  String isAdmin = '0';

  Users();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['gender'] = gender;
    map['birthday'] = birthday;
    map['name'] = name;
    map['email'] = email;
    map['image'] = image;
    map['isAdmin'] = isAdmin;
    return map;
  }
}
