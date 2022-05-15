import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoping_online/firebase/firebase_firestore.dart';
import 'package:shoping_online/firebase/firebase_storage.dart';
import 'package:shoping_online/models/product.dart';
import 'package:shoping_online/utils/helper.dart';
import 'package:shoping_online/widgets/edit_text.dart';

class ProductController extends StatefulWidget {
  final Product? product;

  ProductController(this.product);

  @override
  _ProductControllerState createState() => _ProductControllerState();
}

class _ProductControllerState extends State<ProductController> with Helpers {
  String? category;
  String? categoryName;
  late TextEditingController _name;
  late TextEditingController _categoryId;
  late TextEditingController _price;
  late TextEditingController _disCount;
  late TextEditingController _color;
  late TextEditingController _size;
  late TextEditingController _quantity;
  late TextEditingController _description;

  XFile? pickedImage;
  XFile? pickedImage2;
  ImagePicker imagePicker = ImagePicker();
  late String selectedImage;

  @override
  void initState(){
    super.initState();
    if (widget.product != null) {
      selectedImage = widget.product!.image;
    } else {
      selectedImage = '';
    }
    _name = TextEditingController(
        text: widget.product != null ? widget.product!.name : '');
    _price = TextEditingController(
        text: widget.product != null ? widget.product!.price.toString() : '');
    _disCount = TextEditingController(
        text:
            widget.product != null ? widget.product!.disCount.toString() : '');
    _color = TextEditingController(
        text: widget.product != null ? widget.product!.color : '');
    _size = TextEditingController(
        text: widget.product != null ? widget.product!.size : '');
    _quantity = TextEditingController(
        text:
            widget.product != null ? widget.product!.quantity.toString() : '');
    _description = TextEditingController(
        text: widget.product != null ? widget.product!.description : '');
    getProductCategory();
    _categoryId = TextEditingController(
        text: widget.product != null ? categoryName : '');
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _disCount.dispose();
    _color.dispose();
    _size.dispose();
    _quantity.dispose();
    _description.dispose();
    _categoryId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.product != null ? 'Edit Product' : 'Add Product',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (widget.product != null) {
                  updateProduct();
                } else {
                  addProduct();
                }
              },
              icon: Icon(Icons.check)),
          Visibility(
            visible: widget.product != null,
            child: IconButton(
                onPressed: () {
                  showAlertDialog();
                },
                icon: Icon(Icons.delete_outline)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.deepOrange),
                  child: widget.product != null
                      ? pickedImage2 != null
                          ? Image.file(
                              File(pickedImage2!.path),
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.product!.image,
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
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: EditText(
                      hint: 'Price',
                      icon: Icons.monetization_on_outlined,
                      controller: _price,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: EditText(
                      hint: 'Discount',
                      icon: Icons.money_off,
                      controller: _disCount,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showBottomSheet();
                },
                child: EditText(
                  enabeled: false,
                  hint: 'Select Category',
                  icon: Icons.category_outlined,
                  controller: _categoryId,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: EditText(
                      hint: 'Color',
                      icon: Icons.color_lens_outlined,
                      controller: _color,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: EditText(
                      hint: 'Size',
                      icon: Icons.format_size_outlined,
                      controller: _size,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              EditText(
                hint: 'Quantity',
                icon: Icons.format_list_numbered,
                controller: _quantity,
              ),
              SizedBox(
                height: 20,
              ),
              EditText(
                hint: 'Description',
                icon: Icons.description_outlined,
                controller: _description,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkData() {
    if (_name.text.toString().isNotEmpty &&
        _price.text.toString().isNotEmpty &&
        _description.text.toString().isNotEmpty &&
        _quantity.text.toString().isNotEmpty &&
        _size.text.toString().isNotEmpty &&
        _color.text.toString().isNotEmpty &&
        _categoryId.text.toString().isNotEmpty &&
        _disCount.text.toString().isNotEmpty) {
      if (widget.product != null) {
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

  Future<void> addProductProcess() async {
    bool stats =
        await FirebaseFirestoreController().addProduct(product: product);
    if (stats) {
      Navigator.pop(context);
    }
  }

  Future<void> updateProductProcess() async {
    bool stats = await FirebaseFirestoreController()
        .updateProduct(product: product, path: widget.product!.path);
    if (stats) {
      Navigator.pop(context);
    }
  }

  Product get product {
    Product product = Product();
    product.image = selectedImage;
    product.name = _name.text.toString();
    product.price = double.parse(_price.text.toString());
    product.disCount = double.parse(_disCount.text.toString());
    product.rate = 0.toDouble();
    product.color = _color.text.toString();
    product.size = _size.text.toString();
    product.quantity = int.parse(_quantity.text.toString());
    product.description = _description.text.toString();
    product.categoryId = category!;
    return product;
  }

  Future<void> addProduct() async {
    if (checkData()) {
      await addProductProcess();
    } else {
      showSnackBar(
          context: context,
          content: 'One or more input are empty',
          state: false);
    }
  }

  Future<void> getProductCategory() async{
    categoryName = await FirebaseFirestoreController().getCategoryName(widget.product!.categoryId);
    print(categoryName);
  }

  Future<void> updateProduct() async {
    if (checkData()) {
      await updateProductProcess();
    } else {
      showSnackBar(
          context: context,
          content: 'One or more input are empty',
          state: false);
    }
  }

  Future<void> deleteProduct() async {
    bool stats = await FirebaseFirestoreController()
        .deleteProduct(path: widget.product!.path);
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
        .uploadImagee(File(pickedImage!.path), 'products');
  }

  void showBottomSheet() {
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      context: context,
      builder: (context) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestoreController().readCategory(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      title: Text(documents[index].get('name')),
                      value: documents[index].id,
                      groupValue: category,
                      onChanged: (String? value) {
                        if (value != null)
                          setState( () {
                            category = value;
                              _categoryId.text = documents[index].get('name');
                              Navigator.pop(context);
                            },
                          );
                      },
                    );
                  },
                ),
              );
            }else{
              return Container();
            }
          },
        );
      },

    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete this product',
            style: TextStyle(color: Colors.grey),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () {
                deleteProduct();
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
