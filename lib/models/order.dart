
import 'package:shoping_online/models/orderItem.dart';

class Order{
  double total = 0.0;
  String username = '';
  String email = '';
  String userImage = '';

  Order();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['total'] = total;
    map['username'] = username;
    map['email'] = email;
    map['userImage'] = userImage;
    return map;
  }

  @override
  String toString() {
    return 'Order{total: $total, username: $username, email: $email, userImage: $userImage}';
  }
}