
class Cart{

  String image = '';
  String name = '';
  double price = 0.0;
  double total = 0.0;
  String color = '';
  String size = '';
  int quantity = 0;
  String username = '';
  String email = '';
  String userImage = '';

  Cart();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['image'] = image;
    map['name'] = name;
    map['price'] = price;
    map['total'] = total;
    map['color'] = color;
    map['size'] = size;
    map['quantity'] = quantity;
    map['username'] = username;
    map['email'] = email;
    map['userImage'] = userImage;
    return map;
  }

}