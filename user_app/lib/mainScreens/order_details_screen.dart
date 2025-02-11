import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/shipment_address_design.dart';
import 'package:user_app/widgets/status_banner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global/global.dart';
import '../config.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderId;

  const OrderDetailsScreen({this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  Map<String, dynamic>? orderData;
  Map<String, dynamic>? addressData;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    print("Fetching order details for orderId: ${widget.orderId}");
    final response = await http.get(
      Uri.parse(getOrderDetails + widget.orderId!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("Response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Response data: $data");
      if (data['status'] == true && data['order'] != null) {
        setState(() {
          orderData = data['order'];
          orderStatus = orderData?['orderStatus'] ?? 'Unknown';
          print("Order data: $orderData");
          print("Order status: $orderStatus");
          String addressId = orderData?['address']?['addressId'] ?? '';
          print("Address ID: $addressId");
          if (addressId.isNotEmpty) {
            fetchAddressDetails(addressId);
          } else {
            Fluttertoast.showToast(msg: "Invalid address ID");
          }
        });
      } else {
        print(
            "Failed to fetch order details: ${data['status']}, ${data['order']}");
        Fluttertoast.showToast(msg: "Failed to fetch order details");
      }
    } else {
      print("Failed to fetch order details: ${response.statusCode}");
      Fluttertoast.showToast(msg: "Failed to fetch order details");
    }
  }

  Future<void> fetchAddressDetails(String addressId) async {
    print("Fetching address details for addressId: $addressId");
    final response = await http.get(
      Uri.parse(getAddressDetails + addressId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("Response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Response data: $data");
      if (data['status'] == true) {
        setState(() {
          addressData = data['address'];
          print("Address data: $addressData");
        });
      } else {
        print("Failed to fetch address details: ${data['status']}");
        Fluttertoast.showToast(msg: "Failed to fetch address details");
      }
    } else {
      print("Failed to fetch address details: ${response.statusCode}");
      print("Response body: ${response.body}");
      Fluttertoast.showToast(msg: "Failed to fetch address details");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "moiz: Building OrderDetailsScreen with orderStatus: $orderStatus and addressData: $addressData");
    return Scaffold(
      body: Column(
        children: [
          StatusBanner(orderStatus: orderStatus),
          Expanded(
            child: SingleChildScrollView(
              child: orderData == null
                  ? Center(child: circularProgress())
                  : Container(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Rs ${orderData!["totalAmount"]}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Approximate Time: ${orderData!["approximateTime"]} minutes",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Order at: " +
                                  DateFormat("dd MMMM yyyy hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      DateTime.parse(orderData!["createdAt"])
                                          .millisecondsSinceEpoch,
                                    ),
                                  ),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                            ),
                          ),
                          const Divider(
                            thickness: 4,
                          ),
                          orderStatus == "delivered"
                              ? Image.asset('assets/images/delivered.jpg')
                              : Image.asset('assets/images/state.jpg'),
                          const Divider(
                            thickness: 4,
                          ),
                          addressData == null
                              ? Center(child: circularProgress())
                              : ShipmentAddressDesign(
                                  model: Address.fromJson(addressData!)),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
