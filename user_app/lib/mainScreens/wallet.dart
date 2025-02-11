import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import '../config.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double walletBalance = 0.0;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
  }

  Future<void> fetchWalletBalance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("uid");

    if (userId == null) {
      Fluttertoast.showToast(msg: "User ID is null");
      return;
    }

    final response = await http.get(
      Uri.parse(getOrders + userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        setState(() {
          walletBalance =
              data['wallet'] != null ? data['wallet'].toDouble() : 0.0;
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch wallet balance");
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to fetch wallet balance");
    }
  }

  Future<void> addMoneyToWallet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("uid");

    if (userId == null) {
      Fluttertoast.showToast(msg: "User ID is null");
      return;
    }

    final response = await http.post(
      Uri.parse(addMonyToWallet),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'userId': userId,
        'amount': double.parse(amountController.text),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        setState(() {
          walletBalance =
              data['wallet'] != null ? data['wallet'].toDouble() : 0.0;
        });
        Fluttertoast.showToast(msg: "Money added to wallet successfully");
      } else {
        Fluttertoast.showToast(msg: data['message']);
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to add money to wallet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "Wallet",
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Balance: Rs $walletBalance",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: addMoneyToWallet,
                  child: Text(
                    "Add Money",
                    style: TextStyle(
                      color: Colors.white, // Make the text color white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF261E92),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
