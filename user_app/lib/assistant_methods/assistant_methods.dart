import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/config.dart';
import 'package:user_app/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initializeCart() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.getStringList("userCart") == null) {
    sharedPreferences.setStringList("userCart", []);
  }
}

separateOrderItemIds(orderId) {
  List<String> separateItemIdsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = List<String>.from(orderId);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    separateItemIdsList.add(getItemId);
  }

  return separateItemIdsList;
}

separateItemIds() {
  List<String> separateItemIdsList = [], defaultItemList = [];
  int i = 0;
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    separateItemIdsList.add(getItemId);
  }

  return separateItemIdsList;
}

Future<void> addItemToCart(
    String? foodItemId, BuildContext context, int itemCounter) async {
  // Debugging statements
  print('foodItemId: $foodItemId');
  print('itemCounter: $itemCounter');

  if (foodItemId == null || itemCounter <= 0) {
    Fluttertoast.showToast(msg: "Invalid item or quantity.");
    return;
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<String>? tempList = sharedPreferences.getStringList("userCart") ?? [];
  tempList.add("$foodItemId:$itemCounter"); // e.g., "1210259022:2"

  // Debugging statements
  print('Adding item to cart: $foodItemId, Quantity: $itemCounter');
  print('Updated cart list: $tempList');

  // Update userCart in MongoDB via Node.js backend
  final response = await http.post(
    Uri.parse(updateCart), // Use the correct URL from config.dart
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userId': sharedPreferences.getString("uid"),
      'itemId': foodItemId,
      'quantity': itemCounter,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    Fluttertoast.showToast(msg: "Item Added Successfully.");

    sharedPreferences.setStringList("userCart", tempList);

    // Update the page
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  } else {
    Fluttertoast.showToast(msg: "Failed to add item to cart.");
  }
}

List<String> separateOrderItemQuantities(List<dynamic> orderItems) {
  List<String> separateItemQuantityList = [];

  for (var item in orderItems) {
    String quantity = item['quantity'].toString();
    separateItemQuantityList.add(quantity);
  }

  return separateItemQuantityList;
}

separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quanNumber);
  }

  return separateItemQuantityList;
}

clearCartNow(context) async {
  sharedPreferences!.setStringList("userCart", ['garbageValue']);

  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  // Clear userCart in MongoDB via Node.js backend
  final response = await http.post(
    Uri.parse(clearCart),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userId': sharedPreferences!.getString("uid"), // Ensure 'userId' is sent
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    sharedPreferences!.setStringList("userCart", emptyList!);
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  } else {
    Fluttertoast.showToast(msg: "Failed to clear cart.");
  }
}
