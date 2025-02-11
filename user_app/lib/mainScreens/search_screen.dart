import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/config.dart'; // Import the config file
import 'package:user_app/widgets/sellers_design.dart';
import 'package:user_app/models/sellers.dart';
import 'package:user_app/widgets/progress_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Sellers> sellers = [];
  bool isLoading = false;

  Future<void> findSellersByName(String name) async {
    setState(() {
      isLoading = true;
    });

    final url = findSellerByName;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'searchTerm': name}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          sellers =
              (data as List).map((seller) => Sellers.fromJson(seller)).toList();
        });
      } else {
        print("Failed to find sellers: ${response.statusCode}");
      }
    } catch (e) {
      print("Error finding sellers: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF261E92), Color(0xFF261E92)],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: const Text(
            "Search Sellers",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for sellers...",
                  hintStyle: TextStyle(
                    fontFamily: "Poppins", // Change font to Poppins
                  ),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors
                      .deepPurple[50], // Add background color to TextField
                  prefixIcon: Icon(Icons.search,
                      color: Colors.deepPurple), // Add icon to TextField
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    findSellersByName(value);
                  }
                },
              ),
            ),
            isLoading
                ? Center(child: circularProgress())
                : Expanded(
                    child: ListView.builder(
                      itemCount: sellers.length,
                      itemBuilder: (context, index) {
                        final seller = sellers[index];
                        return SellersDesignWidget(
                          model: seller,
                          context: context,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
