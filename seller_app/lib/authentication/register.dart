import 'dart:io';
import 'package:flutter/material.dart';
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
import 'package:seller_app/widgets/custom_text_input.dart';
import 'package:seller_app/widgets/custom_button.dart';
import 'package:seller_app/widgets/custom_top_bar.dart';
import 'package:seller_app/mainScreens/welcome.dart';
import 'package:seller_app/authentication/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(message: "Please select an image");
          });
    } else if (passwordController.text != confirmPasswordController.text) {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(message: "Passwords don't match");
          });
    } else if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
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

      // Call the function to register user via Node.js API
      await registerUser();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
                message: "Please Enter Required info for registration");
          });
    }
  }

  Future<void> registerUser() async {
    try {
      final url = Uri.parse(register); // Adjust URL to your server

      var request = http.MultipartRequest('POST', url);

      request.fields['name'] = nameController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['password'] = passwordController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['address'] = addressController.text.trim();

      if (imageXFile != null) {
        var stream = http.ByteStream(imageXFile!.openRead());
        var length = await imageXFile!.length();
        var multipartFile = http.MultipartFile('photoUrl', stream, length,
            filename: imageXFile!.name);
        request.files.add(multipartFile);
      }

      print("moiz: Sending request to $url with fields: ${request.fields}");

      var response = await request.send();
      print("moiz: Received response with status code: ${response.statusCode}");

      var responseData = await http.Response.fromStream(response);
      print("moiz: Full response body: ${responseData.body}");

      if (response.statusCode == 201) {
        var responseBody = jsonDecode(responseData.body);
        var sellerData = responseBody['seller'];
        print("moiz: Response data: $sellerData");

        // Save seller data locally
        await saveSellerDataLocally(sellerData);

        // Close loading dialog
        Navigator.pop(context);

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
        print("moiz: Registration failed with response: ${responseData.body}");

        // Close loading dialog
        Navigator.pop(context);

        // Handle error
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                  message: "Registration failed, try again.");
            });
      }
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      print("moiz: An error occurred: $e");

      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(message: "An error occurred: $e");
          });
    }
  }

  Future<void> saveSellerDataLocally(Map<String, dynamic> sellerData) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", sellerData['_id'] ?? '');
    await sharedPreferences!.setString("email", sellerData['email'] ?? '');
    await sharedPreferences!.setString("name", sellerData['name'] ?? '');
    await sharedPreferences!.setString("phone", sellerData['phone'] ?? '');
    await sharedPreferences!.setString("address", sellerData['address'] ?? '');
    await sharedPreferences!
        .setString("photoUrl", sellerData['photoUrl'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTopBar(
              title: 'Register',
              onBackPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const welcome(),
                  ),
                );
              },
            ),
            const SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextInput(
                    label: 'Name',
                    hintText: 'Enter your name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextInput(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextInput(
                    label: 'Phone',
                    hintText: 'Enter your phone number',
                    controller: phoneController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextInput(
                    label: 'Address',
                    hintText: 'Enter your address',
                    controller: addressController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextInput(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 12),
                  CustomTextInput(
                    label: 'Confirm Password',
                    hintText: 'Confirm your password',
                    controller: confirmPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _getImage,
                      child: const Text(
                        "Add Photo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: "Poppins",
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF261E92),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (imageXFile != null)
                    Center(
                      child: Image.file(
                        File(imageXFile!.path),
                        height: 150,
                        width: 150,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Center(
                    child: CustomButton(
                      text: 'Sign Up',
                      onPressed: formValidation,
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 24,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: Color(0xFF838383),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.71,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Log In',
                                    style: TextStyle(
                                      color: Color(0xFF007DFC),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.71,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
