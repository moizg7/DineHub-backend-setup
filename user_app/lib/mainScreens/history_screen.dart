import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/order_card.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import 'package:user_app/config.dart'; // Import the config file

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> deliveredOrders = [];

  @override
  void initState() {
    super.initState();
    fetchDeliveredOrders();
  }

  Future<void> fetchDeliveredOrders() async {
    final userId = sharedPreferences?.getString("uid");
    final url = getDeliveredOrders +
        (userId ?? ''); // Use the new route from config.dart

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            deliveredOrders = data['orders'];
          });
        } else {
          print("Failed to fetch delivered orders: ${data['message']}");
        }
      } else {
        print("Failed to fetch delivered orders: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching delivered orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "History",
        ),
        body: deliveredOrders.isEmpty
            ? Center(child: circularProgress())
            : ListView.builder(
                itemCount: deliveredOrders.length,
                itemBuilder: (c, index) {
                  final order = deliveredOrders[index];
                  final sellerName = order['sellerName'];
                  final sellerImage = order['sellerImage'];
                  final totalPrice = (order['totalAmount'] as int).toDouble();

                  return OrderCard(
                    itemCount: order['cart'].length,
                    data: order['cart'],
                    orderId: order['_id'],
                    seperateQuantitiesList: order['cart']
                        .map<String>((item) => item['quantity'].toString())
                        .toList(),
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
