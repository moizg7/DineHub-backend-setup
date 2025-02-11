import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seller_app/authentication/auth_screen.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/loading_dialog.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/config.dart'; // Import config.dart
import '../widgets/custom_text_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_top_bar.dart';
import 'package:seller_app/mainScreens/welcome.dart'; // Import welcome page
import 'package:seller_app/authentication/register.dart'; // Import register page
import 'package:seller_app/authentication/forgot_password.dart'; // Import forgot password page

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please Enter Email or Password",
            );
          });
    }
  }

  loginNow() async {
    // Show loading dialog
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(
            message: 'Checking Credentials',
          );
        });

    try {
      print("Sending request to: $login");
      final response = await http.post(
        Uri.parse(login), // Use the login URL from config.dart
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      // Log the response status and body
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Dismiss loading dialog
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Check for the expected data structure
        if (data['status'] == true && data['seller'] != null) {
          print("Login successful, seller data: ${data['seller']}");
          readDataAndSetDataLocally(data['seller']);
        } else {
          print("Seller data not found in response");
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(
                  message: 'Seller data not found in response',
                );
              });
        }
      } else {
        // Handle invalid credentials
        print("Invalid credentials");
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: 'Invalid credentials',
              );
            });
      }
    } catch (e) {
      // Dismiss loading dialog in case of error
      Navigator.pop(context);
      print("Error during login: $e");
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(message: "An error occurred: $e");
          });
    }
  }

  Future readDataAndSetDataLocally(Map<String, dynamic> seller) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", seller['id']);
    await sharedPreferences!.setString("email", seller['email']);
    await sharedPreferences!.setString("name", seller['name']);
    await sharedPreferences!.setString("phone", seller['phone']);
    await sharedPreferences!.setString("address", seller['address']);
    await sharedPreferences!.setString("photoUrl", seller['photoUrl']);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTopBar(
              title: 'Log In',
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
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 388,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: const Icon(
                            Icons.check_box_outline_blank_rounded,
                            color: Color.fromARGB(255, 117, 69, 69),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            child: Text(
                              'Remember me',
                              style: TextStyle(
                                color: Color(0xFF1B1B1B),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF838383),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CustomButton(
                            text: 'Log In',
                            onPressed: formValidation,
                            width: 200, // Adjust the width of the button
                          ),
                        ),
                        const SizedBox(height: 28),
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
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Dont’t have an account? ',
                                          style: TextStyle(
                                            color: Color(0xFF838383),
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 1.71,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Register',
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
          ],
        ),
      ),
    );
  }
}
