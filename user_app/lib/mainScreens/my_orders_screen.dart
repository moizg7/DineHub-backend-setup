import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/order_card.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
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
          orders = data['orders'];
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch orders");
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to fetch orders");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "My Orders",
        ),
        body: orders.isEmpty
            ? Center(
                child: circularProgress(),
              )
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (c, index) {
                  final order = orders[index];
                  final sellerName = order['sellerName'];
                  final sellerImage = order['sellerImage'];
                  final totalPrice = (order['totalAmount'] as int).toDouble();

                  return OrderCard(
                    itemCount: order['cart'].length,
                    data: order['cart'],
                    orderId: order['_id'],
                    seperateQuantitiesList:
                        separateOrderItemQuantities(order['cart']),
                    sellerName: sellerName,
                    sellerImage: sellerImage,
                    totalPrice: totalPrice,
                  );
                },
              ),
      ),
    );
  }
}
