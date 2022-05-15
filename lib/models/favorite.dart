class Favorite{
  String userId = '';
  String productId = '';

  Favorite();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['userId'] = userId;
    map['productId'] = productId;
    return map;
  }
}