
import 'dart:ffi';

class Product{

  String image = '';
  String name = '';
  double price = 0.0;
  double disCount = 0.0;
  double rate = 0;
  String color = '';
  String size = '';
  int quantity = 0;
  String description = '';
  String categoryId = '';
  String path = '';
  String favorite = '0';
  String created = DateTime.now().toString();

  Product();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['image'] = image;
    map['price'] = price;
    map['disCount'] = disCount;
    map['rate'] = rate;
    map['color'] = color;
    map['size'] = size;
    map['quantity'] = quantity;
    map['description'] = description;
    map['category_id'] = categoryId;
    map['created'] = created;
    map['favorite'] = favorite;
    return map;
  }

}