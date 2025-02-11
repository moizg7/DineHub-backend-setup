import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:seller_app/config.dart';

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
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
          "Add New Menu",
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
              const SizedBox(
                height: 100,
              ),
              const Icon(
                Icons.shop_two,
                color: Colors.white,
                size: 200,
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(
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
                  'Add New Menu',
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

  menusUploadFormScreen() {
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
          "Uploading New Menu",
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
                color: Color.fromARGB(255, 250, 250, 250),
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
                    hintText: "Menu Title",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins", // Change font to Poppins
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
              Icons.perm_device_information,
              color: Color.fromRGBO(2, 3, 129, 1),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                    hintText: "Menu Info",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins", // Change font to Poppins
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
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // start uploading the image and menu info
        await uploadImageAndMenu(File(imageXFile!.path));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "Please write title and info for menu",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please Pick an image for Menu",
            );
          });
    }
  }

  uploadImageAndMenu(File mImageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(createmenu),
    );
    request.files.add(
        await http.MultipartFile.fromPath('thumbnailUrl', mImageFile.path));
    request.fields['sellerUID'] = sharedPreferences!.getString("uid")!;
    request.fields['menuTitle'] = titleController.text;
    request.fields['menuInfo'] = shortInfoController.text;
    request.fields['publishedDate'] = DateTime.now().toIso8601String();
    request.fields['status'] = 'available';

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      if (jsonResponse['status'] == true) {
        clearMenuUploadForm();
        setState(() {
          uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
          uploading = false;
        });
      } else {
        throw Exception(
            'Failed to upload image and menu: ${jsonResponse['message']}');
      }
    } else {
      throw Exception(
          'Failed to upload image and menu: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
