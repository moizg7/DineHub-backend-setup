import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/config.dart';
import '../splashScreen/splash_screen.dart';
import 'package:seller_app/mainScreens/home_screen.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  double sellerTotalEarnings = 0;

  @override
  void initState() {
    super.initState();
    retrieveSellersEarnings();
  }

  Future<void> retrieveSellersEarnings() async {
    final sellerUID = sharedPreferences!.getString("uid");
    final url = Uri.parse(getTotalEarnings + sellerUID!);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            sellerTotalEarnings = data['totalEarnings'].toDouble();
          });
        } else {
          throw Exception('Failed to load earnings: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load earnings');
      }
    } catch (error) {
      print("Error fetching earnings: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rs $sellerTotalEarnings",
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: "Poppins",
              ),
            ),
            const Text(
              "Total Earnings",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                thickness: 1.5,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => HomeScreen()));
              },
              child: const Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 40, horizontal: 120),
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  title: Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: "Poppins",
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
