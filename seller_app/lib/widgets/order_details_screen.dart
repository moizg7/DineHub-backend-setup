// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_app/model/address.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:seller_app/widgets/shipment_address_design.dart';
import 'package:seller_app/widgets/status_banner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seller_app/config.dart';
import 'package:seller_app/widgets/simple_Appbar.dart';

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
  String approximateTime = "";

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    print("moiz: Fetching order details for orderId: ${widget.orderId}");
    final response = await http.get(
      Uri.parse(getOrderDetails + widget.orderId!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("moiz: Response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("moiz: Response data: $data");
      if (data['status'] == true && data['order'] != null) {
        setState(() {
          orderData = data['order'];
          orderStatus = orderData?['orderStatus'] ?? 'Unknown';
          print("moiz: Order data: $orderData");
          print("moiz: Order status: $orderStatus");
          String addressId = orderData?['address']?['addressId'] ?? '';
          print("moiz: Address ID: $addressId");
          if (addressId.isNotEmpty) {
            fetchAddressDetails(addressId);
          } else {
            print("moiz: Invalid address ID");
          }
        });
      } else {
        print(
            "moiz: Failed to fetch order details: ${data['status']}, ${data['order']}");
      }
    } else {
      print("moiz: Failed to fetch order details: ${response.statusCode}");
    }
  }

  Future<void> fetchAddressDetails(String addressId) async {
    print("moiz: Fetching address details for addressId: $addressId");
    final response = await http.get(
      Uri.parse(getUserAddress + addressId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("moiz: Response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("moiz: Response data: $data");
      if (data['status'] == true) {
        setState(() {
          addressData = data['address'];
          print("moiz: Address data: $addressData");
        });
      } else {
        print("moiz: Failed to fetch address details: ${data['status']}");
      }
    } else {
      print("moiz: Failed to fetch address details: ${response.statusCode}");
      print("moiz: Response body: ${response.body}");
    }
  }

  Future<void> updateOrderStatus(String status) async {
    final response = await http.post(
      Uri.parse(updateOrderStat),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'orderId': widget.orderId,
        'status': status,
        'approximateTime': approximateTime,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        setState(() {
          orderStatus = status;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "moiz: Building OrderDetailsScreen with orderStatus: $orderStatus and addressData: $addressData");
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Order Details",
      ),
      body: orderData == null
          ? Center(child: circularProgress())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: ${widget.orderId}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Address: ${addressData?['RoomNo'] ?? 'Unknown'}, ${addressData?['Hostel'] ?? 'Unknown'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (orderStatus == "pending") ...[
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Approximate Time (in minutes)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        approximateTime = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        updateOrderStatus("accepted");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF261E92),
                      ),
                      child: const Text(
                        'Accept Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ] else if (orderStatus == "accepted") ...[
                    ElevatedButton(
                      onPressed: () {
                        updateOrderStatus("on way");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF261E92),
                      ),
                      child: const Text(
                        'Cooked',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ] else if (orderStatus == "on way") ...[
                    const Center(
                      child: Text(
                        "Order is on the way",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
