import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/mainScreens/itemsScreen.dart';
import 'package:seller_app/model/menus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seller_app/config.dart';

class InfoDesignWidget extends StatefulWidget {
  final Menus model;
  final BuildContext context;

  InfoDesignWidget({required this.model, required this.context, Key? key})
      : super(key: key);

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  void deleteMenu(String menuId) async {
    try {
      final response = await http.post(
        Uri.parse(delMenu),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'menuId': menuId,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          Fluttertoast.showToast(msg: "Menu Deleted Successfully");
          // Navigate to home screen after deletion
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: "Failed to delete menu");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to delete menu");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("InfoDesignWidget: menuId = ${widget.model.menuId}"); // Debug print
    return InkWell(
      onTap: () {
        print(
            "Navigating to ItemsScreen with menuId: ${widget.model.menuId}"); // Debug print
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemsScreen(model: widget.model)),
        );
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Center(
                child: Image.network(
                  widget.model.thumbnailUrl ?? '',
                  height: 220,
                  width: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model.menuTitle ?? '',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontFamily: "Poppins",
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteMenu(widget.model.menuId ?? '');
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Color.fromARGB(255, 57, 89, 205),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 4,
                thickness: 2,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
