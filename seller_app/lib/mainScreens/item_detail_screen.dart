import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/models/items.dart';
import 'package:seller_app/mainScreens/home_screen.dart'; // Import HomeScreen
import 'package:seller_app/widgets/simple_Appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seller_app/config.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items model;
  const ItemDetailsScreen({super.key, required this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItemFromServer(String itemId) async {
    if (itemId.isNotEmpty) {
      final url = Uri.parse(
          deleteItem); // Ensure deleteItem is a string from config.dart
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'itemId': itemId,
        }),
      );

      print("Response status code: ${response.statusCode}"); // Debug print
      print("Response body: ${response.body}"); // Debug print

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          Fluttertoast.showToast(msg: "Item deleted successfully");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Fluttertoast.showToast(
              msg: "Failed to delete item: ${data['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to delete item: ${response.body}");
        throw Exception('Failed to delete item');
      }
    } else {
      Fluttertoast.showToast(msg: "Item ID is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: sharedPreferences!.getString("name"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.model.thumbnailUrl ?? '',
                height: 220,
                width: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.itemName ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.longDescription ?? '',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Rs ${widget.model.price?.toString() ?? ''}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  deleteItemFromServer(widget.model.itemId!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF261E92),
                        Color(0xFF261E92),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 13,
                  child: const Center(
                    child: Text(
                      "Delete this item",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
