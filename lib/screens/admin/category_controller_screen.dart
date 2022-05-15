import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/firebase/firebase_storage.dart';
import 'package:shoping_online/models/category.dart';
import 'package:shoping_online/utils/getx_controller.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/edit_text.dart';

class CategoryController extends StatefulWidget {
  final Category? category;

  CategoryController(this.category);

  @override
  _CategoryControllerState createState() => _CategoryControllerState();
}

class _CategoryControllerState extends State<CategoryController> with Helpers {
  late TextEditingController _name;
  XFile? pickedImage;
  XFile? pickedImage2;
  ImagePicker imagePicker = ImagePicker();
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      selectedImage = widget.category!.image;
    } else {
      selectedImage = '';
    }
    _name = TextEditingController(
        text: widget.category != null ? widget.category!.name : '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.category != null ? 'Edit Category' : 'Add Category',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (widget.category != null) {
                  updateCategory();
                } else {
                  addCategory();
                }
              },
              icon: Icon(Icons.check)),
          Visibility(
            visible: widget.category != null,
            child: IconButton(
                onPressed: () {
                  showAlertDialog();
                },
                icon: Icon(Icons.delete_outline)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, '/select_image_screen');
                pickImage();
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepOrange),
                child: widget.category != null
                    ? pickedImage2 != null
                        ? Image.file(
                            File(pickedImage2!.path),
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.category!.image,
                            fit: BoxFit.cover,
                          )
                    : pickedImage2 != null
                        ? Image.file(
                            File(pickedImage2!.path),
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            EditText(
              hint: 'Name',
              icon: Icons.category_outlined,
              controller: _name,
            ),
          ],
        ),
      ),
    );
  }

  bool checkData() {
    if (_name.text.toString().isNotEmpty) {
      if (widget.category != null) {
        return true;
      } else {
        if (selectedImage != '') {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<void> addCategoryProcess() async {
    bool stats =
        await FirebaseFirestoreController().addCategory(category: category);
    if (stats) {
      Navigator.pop(context);
    }
  }

  Future<void> updateCategoryProcess() async {
    bool stats = await FirebaseFirestoreController()
        .updateCategory(category: category, path: widget.category!.path);
    if (stats) {
      Navigator.pop(context);
    }
  }

  Category get category {
    Category category = Category();
    category.image = selectedImage;
    category.name = _name.text.toString();
    return category;
  }

  Future<void> addCategory() async {
    if (checkData()) {
      await addCategoryProcess();
    } else {
      showSnackBar(
          context: context,
          content: 'One or more input are empty',
          state: false);
    }
  }

  Future<void> updateCategory() async {
    if (checkData()) {
      await updateCategoryProcess();
    } else {
      showSnackBar(
          context: context,
          content: 'One or more input are empty',
          state: false);
    }
  }

  Future<void> deleteCategory() async {
    bool stats = await FirebaseFirestoreController()
        .deleteCategory(path: widget.category!.path);
    if (stats) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> pickImage() async {
    pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(uploadImage(),
            message: Text('Uploading image...')),
      );
      setState(() {
        pickedImage2 = pickedImage;
      });
    }
  }

  Future<void> uploadImage() async {
    selectedImage = await FirebaseStorageController()
        .uploadImagee(File(pickedImage!.path), 'categories');
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text(
            'Are you sure you want to delete this category',
            style: TextStyle(color: Colors.grey),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () {
                deleteCategory();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }
}
