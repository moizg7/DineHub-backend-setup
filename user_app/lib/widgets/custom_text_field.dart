import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool? enabled = true;

  CustomTextField(
      {super.key,
      this.controller,
      this.data,
      this.hintText,
      this.isObsecre,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 140, 173, 216),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefix: Icon(
              data,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText),
      ),
    );
  }
}
