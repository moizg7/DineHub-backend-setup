import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/model/menus.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:seller_app/config.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  ItemsUploadScreen({this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool uploading = false;

  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF261E92),
                Color(0xFF261E92),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "Add New Items",
          style: TextStyle(
              fontSize: 24, fontFamily: "Poppins", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 73, 71, 179),
              Color.fromARGB(255, 130, 155, 255)
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.shop_two,
                color: Colors.white,
                size: 200,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 16, 42, 137)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  takeImage(context);
                },
                child: const Text(
                  'Add New Items',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Menu Image",
              style: TextStyle(
                  color: Color.fromARGB(255, 16, 42, 137),
                  fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: captureImageWithCamera,
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: pickImageFromGallery,
                child: const Text(
                  "Select from Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);
    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 720, maxWidth: 1280);
    setState(() {
      imageXFile;
    });
  }

  ItemsUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF261E92),
                Color(0xFF261E92),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "Uploading New Item",
          style: TextStyle(
              fontSize: 20, fontFamily: "Poppins", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            clearMenuUploadForm();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: uploading ? null : () => validateUploadForm(),
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(
                          File(imageXFile!.path),
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Color.fromRGBO(2, 3, 129, 1),
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Color.fromRGBO(2, 3, 129, 1),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: "Poppins"),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Color.fromRGBO(2, 3, 129, 1),
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Color.fromRGBO(2, 3, 129, 1),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                    hintText: "Info",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Color.fromRGBO(2, 3, 129, 1),
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Color.fromRGBO(2, 3, 129, 1),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Color.fromRGBO(2, 3, 129, 1),
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.currency_exchange,
              color: Color.fromRGBO(2, 3, 129, 1),
            ),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Color.fromRGBO(2, 3, 129, 1),
            thickness: 2,
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // Upload both image and item info together
        await uploadImageAndItem(File(imageXFile!.path));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "Please fill in all fields",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please Pick an image for item",
            );
          });
    }
  }

  uploadImageAndItem(File mImageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(createitem),
    );

    print("Uploading to URL: $createitem");

    // Add the image file first
    request.files.add(
        await http.MultipartFile.fromPath('thumbnailUrl', mImageFile.path));

    // Add fields with correct names
    request.fields['menuId'] = widget.model!.menuId!;
    request.fields['sellerUID'] = sharedPreferences!.getString("uid")!;
    request.fields['title'] = titleController.text;
    request.fields['shortInfo'] = shortInfoController.text;
    request.fields['longDescription'] = descriptionController.text;
    request.fields['price'] = priceController.text;
    request.fields['status'] = 'available';

    print("Fields being sent: ${request.fields}");

    try {
      final response = await request.send();
      print("Response status: ${response.statusCode}");

      final responseData = await response.stream.bytesToString();
      print("Response body: $responseData");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        if (jsonResponse['status'] == true) {
          clearMenuUploadForm();
          setState(() {
            uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
            uploading = false;
          });
        } else {
          throw Exception('Failed to upload: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to upload: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error uploading: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : ItemsUploadFormScreen();
  }
}
