import 'package:flutter/material.dart';
import 'dart:convert'; // Import for jsonDecode
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/widgets/custom_text_input.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/config.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import '../global/global.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_top_bar.dart';
import 'package:user_app/mainScreens/welcome.dart'; // Import welcome page
import 'package:user_app/authentication/login.dart'; // Import login page

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

  Future<void> formValidation() async {
    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(message: "Passwords don't match");
          });
    } else if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
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

      var requestBody = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
      };

      // Debug print statement to log the request payload
      print("Register request payload: $requestBody");

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // Debug print statement to log the server response
      print("Register server response: ${response.body}");

      if (response.statusCode == 200) {
        // Assuming the server responds with the user data in the body
        var responseData = jsonDecode(response.body);
        var userData = responseData['user'];

        // Save user data locally
        await saveUserDataLocally(userData);

        // Close loading dialog
        Navigator.pop(context);

        // Show success message
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                  message:
                      "User registered successfully!"); // Success message dialog
            });

        // Navigate to home screen after a short delay
        await Future.delayed(const Duration(seconds: 2));
        Route newRoute =
            MaterialPageRoute(builder: (context) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      } else {
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

      // Debug print statement to log the error
      print("Error: $e");

      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(message: "An error occurred: $e");
          });
    }
  }

  Future<void> saveUserDataLocally(Map<String, dynamic> userData) async {
    sharedPreferences = await SharedPreferences.getInstance();

    // Debug print statements to log the values
    print("User ID: ${userData['id']}");
    print("User Email: ${userData['email']}");
    print("User Name: ${userData['name']}");
    print("User Phone: ${userData['phone']}");

    await sharedPreferences!.setString("uid", userData['id'] ?? '');
    await sharedPreferences!.setString("email", userData['email'] ?? '');
    await sharedPreferences!.setString("name", userData['name'] ?? '');
    await sharedPreferences!.setString("phone", userData['phone'] ?? '');
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
                  const SizedBox(height: 12), // Adjusted height
                  CustomTextInput(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 12), // Adjusted height
                  CustomTextInput(
                    label: 'Phone',
                    hintText: 'Enter your phone number',
                    controller: phoneController,
                  ),
                  const SizedBox(height: 12), // Adjusted height
                  CustomTextInput(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 12), // Adjusted height
                  CustomTextInput(
                    label: 'Confirm Password',
                    hintText: 'Confirm your password',
                    controller: confirmPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24), // Adjusted height
                  Center(
                    child: CustomButton(
                      text: 'Sign Up',
                      onPressed: formValidation,
                      width: 200, // Adjust the width of the button
                    ),
                  ),
                  const SizedBox(height: 20), // Adjusted height
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
