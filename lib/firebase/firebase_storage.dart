import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageController {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List<Reference>> getImage() async {
    ListResult listResult = await _firebaseStorage.ref('images').listAll();
    if (listResult.items.isNotEmpty) {
      return listResult.items;
    }
    return [];
  }

  Future<String> uploadImage ({required File file, required String name}) async{
      Reference image = _firebaseStorage.ref('images/$name');
      await image.putFile(file);
      return await image.getDownloadURL();
  }

  Future<String> uploadImagee(File file, String path) async{
    var uuid = Uuid();
    String name = '$path/${uuid.v4()}';
    var image = _firebaseStorage.ref(name);
    await image.putFile(file);
    return await image.getDownloadURL();
  }

}
