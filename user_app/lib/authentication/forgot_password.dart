import 'package:flutter/material.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_top_bar.dart';
import '../widgets/success_dialog.dart'; // Import SuccessDialog
import 'package:user_app/mainScreens/welcome.dart'; // Import welcome page

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTopBar(
              title: 'Forgot Password',
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
                  Text(
                    'Enter the email associated with your account and we’ll send an email with code to reset your password',
                    style: TextStyle(
                      color: Color(0xFF838383),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextInput(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: CustomButton(
                      text: 'Confirm',
                      onPressed: () {
                        // Show success dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const SuccessDialog(
                              message: "Email sent successfully!",
                            );
                          },
                        );
                      },
                      width: 200, // Adjust the width of the button
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
