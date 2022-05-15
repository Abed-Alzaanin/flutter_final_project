
class Category{

  String image = '';
  String name = '';
  String path = '';

  Category();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['image'] = image;
    return map;
  }

}