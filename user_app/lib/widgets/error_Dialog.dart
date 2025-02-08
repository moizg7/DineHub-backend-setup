import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  const ErrorDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(
        message!,
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF261E92)),
          child: const Center(
            child: Text(
              'OK',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
