import 'package:flutter/material.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/widgets/order_card.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:seller_app/widgets/simple_Appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seller_app/config.dart';
import 'package:seller_app/assistant_methods/assistant_methods.dart'; // Import the assistant methods

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({super.key});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  List<Map<String, dynamic>> _ordersList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNewOrders();
  }

  Future<void> fetchNewOrders() async {
    final sellerUID = sharedPreferences!.getString("uid");
    final url = Uri.parse(getNewOrders + sellerUID!);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            _ordersList = List<Map<String, dynamic>>.from(data['orders']);
          });
          print("moiz, Orders fetched successfully: $_ordersList");
        } else {
          throw Exception('Failed to load orders: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      print("Error fetching orders: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrderItems(
      List<String> productIds) async {
    final url = Uri.parse(getItemsByIds);
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'itemIds': productIds,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          print("moiz, Items fetched successfully: ${data['items']}");
          return List<Map<String, dynamic>>.from(data['items']);
        } else {
          throw Exception('Failed to load items: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load items');
      }
    } catch (error) {
      print("Error fetching items: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "New Orders",
        ),
        body: _isLoading
            ? Center(
                child: circularProgress(),
              )
            : _ordersList.isEmpty
                ? Center(
                    child: Text(
                      "No new orders available",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Poppins",
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _ordersList.length,
                    itemBuilder: (c, index) {
                      final order = _ordersList[index];
                      final productIds = order['productIds'] != null
                          ? List<String>.from(order['productIds'])
                          : [];

                      print("moiz, Order ID: ${order['_id']}");
                      print("moiz, Product IDs: $productIds");

                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchOrderItems(productIds.cast<String>()),
                        builder: (c, snap) {
                          return snap.connectionState == ConnectionState.waiting
                              ? Center(
                                  child: circularProgress(),
                                )
                              : snap.hasData
                                  ? OrderCard(
                                      itemCount: snap.data?.length ?? 0,
                                      data: snap.data ?? [],
                                      orderId: order['_id'],
                                      seperateQuantitiesList:
                                          separateOrderItemQuantities(
                                              order['cart']),
                                      sellerName: order['userName'],
                                      totalPrice:
                                          order['totalAmount'].toDouble(),
                                    )
                                  : Center(
                                      child: Text(
                                        "Failed to load items",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
