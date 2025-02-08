import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import 'package:user_app/config.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_top_bar.dart';
import 'package:user_app/mainScreens/welcome.dart'; // Import welcome page
import 'package:user_app/authentication/register.dart'; // Import register page
import 'package:user_app/authentication/forgot_password.dart'; // Import forgot password page

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
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(
            message: 'Checking Credentials',
          );
        });

    final response = await http.post(
      Uri.parse(login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    Navigator.pop(context);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Debug print statement to log the entire server response
      print("Server response: ${response.body}");

      if (data['user'] != null) {
        readDataAndSetDataLocally(data['user']);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: 'User data not found in response',
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: 'Invalid credentials',
            );
          });
    }
  }

  Future readDataAndSetDataLocally(Map<String, dynamic> user) async {
    await sharedPreferences!.setString("uid", user['id']);
    await sharedPreferences!.setString("email", user['email']);
    await sharedPreferences!.setString("name", user['name']);
    await sharedPreferences!.setString("phone", user['phone']);

    List<String> userCartList =
        user['userCart'] != null ? List<String>.from(user['userCart']) : [];
    await sharedPreferences!.setStringList("userCart", userCartList);

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
