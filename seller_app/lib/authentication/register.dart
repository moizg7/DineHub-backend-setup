import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seller_app/config.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_Dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmePasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";

  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;

    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMarks = placeMarks![0];
    completeAddress =
        '${pMarks.subThoroughfare} ${pMarks.thoroughfare},${pMarks.subLocality} ${pMarks.locality},${pMarks.subAdministrativeArea}, ${pMarks.administrativeArea} ${pMarks.postalCode},${pMarks.country}';
    locationController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(message: "Please select an image");
          });
    } else if (passwordController.text != confirmePasswordController.text) {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(message: "Passwords don't match");
          });
    } else if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        locationController.text.isNotEmpty) {
      // Show loading dialog
      showDialog(
          context: context,
          barrierDismissible:
              false, // Prevents dialog dismissal by tapping outside
          builder: (context) {
            return const LoadingDialog(
              message: "Registering Account...",
            );
          });

      // Call the function to register seller via Node.js API
      await registerSeller();

      // Close loading dialog after response
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
                message: "Please Enter Required info for registration");
          });
    }
  }

  Future<void> registerSeller() async {
    try {
      final url = Uri.parse(register); // Adjust URL to your server

      var request = http.MultipartRequest('POST', url);

      request.fields['name'] = nameController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['password'] = passwordController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['address'] = locationController.text.trim();

      if (imageXFile != null) {
        var stream = http.ByteStream(imageXFile!.openRead());
        var length = await imageXFile!.length();
        var multipartFile = http.MultipartFile('photo', stream, length,
            filename: imageXFile!.name);
        request.files.add(multipartFile);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        // Assuming the server responds with the seller data in the body
        var responseData = await http.Response.fromStream(response);
        var sellerData = jsonDecode(responseData.body);

        // Save seller data locally
        await saveSellerDataLocally(sellerData);

        // Show success message
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                  message:
                      "Seller registered successfully!"); // Success message dialog
            });

        // Navigate to home screen after a short delay
        await Future.delayed(const Duration(seconds: 2));
        Route newRoute =
            MaterialPageRoute(builder: (context) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      } else {
        // Handle error
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                  message: "Registration failed, try again.");
            });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(message: "An error occurred: $e");
          });
    }
  }

  Future<void> saveSellerDataLocally(Map<String, dynamic> sellerData) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", sellerData['uid']);
    await sharedPreferences!.setString("email", sellerData['email']);
    await sharedPreferences!.setString("name", sellerData['name']);
    await sharedPreferences!.setString("photo", sellerData['photo']);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(
                          File(imageXFile!.path),
                        ),
                  child: imageXFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.grey,
                        )
                      : null),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: 'Name',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: 'Email',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: 'Password',
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmePasswordController,
                    hintText: 'Confirm Password',
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: 'Phone',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: 'Cafe/Restaurent Address',
                    isObsecre: false,
                    enabled: true,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //  print(completeAddress.toString());
                        setState(() {
                          getCurrentLocation();
                        });
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Get My Current Location',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 250, 171, 119),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => {
                formValidation(),
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(2, 3, 129, 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
              child: const Text(
                "Sign Up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
