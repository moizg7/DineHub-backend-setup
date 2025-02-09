import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import 'package:user_app/widgets/text_field.dart';
import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAddressScreen extends StatelessWidget {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _roomNo = TextEditingController();
  final TextEditingController _hostel = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "DineHub",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            final address = {
              'RoomNo': _roomNo.text.trim(),
              'Hostel': _hostel.text.trim(),
            };

            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            String? userId = sharedPreferences.getString("uid");

            if (userId == null) {
              Fluttertoast.showToast(msg: "User ID is null");
              return;
            }

            final response = await http.post(
              Uri.parse(addAddress),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'userId': userId,
                'address': address,
              }),
            );

            if (response.statusCode == 200) {
              Fluttertoast.showToast(msg: "New Address has been saved.");
              formKey.currentState!.reset();
            } else {
              Fluttertoast.showToast(msg: "Failed to save address.");
            }
          }
        },
        label: const Text(
          "Save Now",
          style: TextStyle(color: Colors.white), // Change text color to white
        ),
        backgroundColor: Color(0xFF261E92),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 6,
            ),
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Save New Address :",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Room No",
                    controller: _roomNo,
                  ),
                  MyTextField(
                    hint: "Hostel",
                    controller: _hostel,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
