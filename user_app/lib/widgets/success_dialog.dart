import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String? message;
  const SuccessDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 24.0,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message!,
              style: const TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
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
