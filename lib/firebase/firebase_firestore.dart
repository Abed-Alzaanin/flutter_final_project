import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoping_online/firebase/firebase_auth.dart';
import 'package:shoping_online/models/cart.dart';
import 'package:shoping_online/models/category.dart';
import 'package:shoping_online/models/favorite.dart';
import 'package:shoping_online/models/order.dart';
import 'package:shoping_online/models/product.dart';
import 'package:shoping_online/models/user.dart';
import 'package:shoping_online/preferences/app_preferences.dart';

class FirebaseFirestoreController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // ******************* User Collection ******************* //

  Future<bool> addUser(Users user) async {
    return await _firebaseFirestore
        .collection('user')
        .add(user.toMap())
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateUser({required String? path, required Users user}) async {
    return await _firebaseFirestore
        .collection('user')
        .doc(path)
        .update(user.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateUserImage(
      {required String? path, required String image}) async {
    return await _firebaseFirestore
        .collection('user')
        .doc(path)
        .update({'image': image})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteUser({required String path, required Users user}) async {
    return await _firebaseFirestore
        .collection('user')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> readUser() async* {
    yield* _firebaseFirestore
        .collection('user')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();
  }

  Future<List<String>> getUser() async {
    return await _firebaseFirestore
        .collection('user')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      String name = value.docs[0].get('name');
      String image = value.docs[0].get('image');
      List<String> data = <String>[name, image];
      return data;
    });
  }

  Future<String> getUserType(String email) async {
    return _firebaseFirestore
        .collection('user')
        .where('email', isEqualTo: email)
        .get()
        .then((value) => value.docs[0].get('isAdmin'));
  }

  // ******************** Category Collection ******************** //

  Future<bool> addCategory({required Category category}) async {
    return await _firebaseFirestore
        .collection('category')
        .add(category.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateCategory(
      {required String? path, required Category category}) async {
    return await _firebaseFirestore
        .collection('category')
        .doc(path)
        .update(category.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteCategory({required String? path}) async {
    return await _firebaseFirestore
        .collection('category')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> readCategory() async* {
    yield* _firebaseFirestore.collection('category').snapshots();
  }

  Future<String> getCategoryName(String id) async {
    return await _firebaseFirestore
        .collection('category')
        .doc(id)
        .get()
        .then((value) => value.get('name'));
  }

  // ******************** Product Collection ******************** //

  Future<bool> addProduct({required Product product}) async {
    return await _firebaseFirestore
        .collection('product')
        .add(product.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateProduct(
      {required String? path, required Product product}) async {
    return await _firebaseFirestore
        .collection('product')
        .doc(path)
        .update(product.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteProduct({required String? path}) async {
    return await _firebaseFirestore
        .collection('product')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> favorite({required String? path}) async {
    return await _firebaseFirestore
        .collection('product')
        .doc(path)
        .update({'favorite': '1'})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> notFavorite({required String? path}) async {
    return await _firebaseFirestore
        .collection('product')
        .doc(path)
        .update({'favorite': '0'})
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> readProductByCategory(String categoryId) async* {
    yield* _firebaseFirestore
        .collection('product')
        .where('category_id', isEqualTo: categoryId)
        .snapshots();
  }

  Stream<QuerySnapshot> readProduct() async* {
    yield* _firebaseFirestore
        .collection('product')
        //.where('category_id', isEqualTo: categoryId)
        .snapshots();
  }

  Stream<QuerySnapshot> readDiscountProduct() async* {
    yield* _firebaseFirestore
        .collection('product')
        .where('disCount', isGreaterThan: 0.0)
        .snapshots();
  }

  Stream<QuerySnapshot> readNewProduct() async* {
    yield* _firebaseFirestore
        .collection('product')
        .orderBy('created', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> readFavoriteProduct() async* {
    yield* _firebaseFirestore
        .collection('product')
        .where('favorite', isEqualTo: '1')
        .snapshots();
  }

  // ******************** Cart Collection ******************** //

  Future<bool> addToCart({required Cart cart}) async {
    return await _firebaseFirestore
        .collection('cart')
        .add(cart.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteCart({required String? path}) async {
    return await _firebaseFirestore
        .collection('cart')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> readCart() async* {
    yield* _firebaseFirestore
        .collection('cart')
        .where('email', isEqualTo: FirebaseAuthController().user.email)
        .snapshots();
  }

  // ******************** Favorite Collection ******************** //

  Future<bool> addFavorite({required Favorite favorite}) async {
    return await _firebaseFirestore
        .collection('favorite')
        .add(favorite.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<String> getFavoriteID(String id) async {
    return await _firebaseFirestore
        .collection('favorite')
        .where('productId', isEqualTo: id)
        .get()
        .then((value) => value.docs[0].id);
  }

  Future<bool> deleteFavorite({required String? path}) async {
    return await _firebaseFirestore
        .collection('favorite')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> readFavorite(List<String> list) async* {
    yield* _firebaseFirestore
        .collection('product')
        .where(FieldPath.documentId, whereIn: list)
        .snapshots();
  }

  Future<bool> isFavorite(String id) async {
    return await _firebaseFirestore
        .collection('favorite')
        .where('userId', isEqualTo: FirebaseAuthController().user.uid)
        .where('productId', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<List<String>> favoriteIds() async {
    List<String> ids = <String>[];
    return await _firebaseFirestore
        .collection('favorite')
        .where('userId', isEqualTo: FirebaseAuthController().user.uid)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        ids.add(value.docs[i].get('productId'));
      }
      return ids;
    });
  }

  // ******************** Order Collection ******************** //

  Future<bool> addOrder({required Order order}) async {
    return await _firebaseFirestore
        .collection('order')
        .add(order.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteOrder({required String? path}) async {
    return await _firebaseFirestore
        .collection('order')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> readOrder() async* {
    yield* _firebaseFirestore.collection('order').snapshots();
  }
}
