import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totolAmmount;
  String? sellerUID;

  PlacedOrderScreen(
      {super.key, this.addressID, this.totolAmmount, this.sellerUID});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> addOrderDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("uid");

    if (userId == null) {
      Fluttertoast.showToast(msg: "User ID is null");
      return;
    }

    final orderData = {
      "userId": userId,
      "address": {
        "addressId": widget.addressID,
      },
      "paymentType": "Cash on Delivery",
      "approximateTime": orderId,
    };

    final response = await http.post(
      Uri.parse(placeOrder),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        clearCartNow(context);
        setState(() {
          orderId = "";
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          Fluttertoast.showToast(
              msg: "Congratulations, Order has been placed Successfully");
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to place order");
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to place order");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/delivery.jpg"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              addOrderDetails();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Place order'),
          )
        ]),
      ),
    );
  }
}
