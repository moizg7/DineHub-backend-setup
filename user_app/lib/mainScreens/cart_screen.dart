import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/mainScreens/address_screen.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../assistant_methods/total_ammount.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/cart_item_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';
import '../services/payment_service.dart'; // Import PaymentService
import '../config.dart'; // Import config for API endpoints
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  const CartScreen({super.key, this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Items> cartItems = [];
  List<int>? separateItemQuantityList;
  num totolAmmount = 0;
  PaymobResponse? response;
  final PaymentService _paymentService =
      PaymentService(); // Initialize PaymentService

  @override
  void initState() {
    super.initState();
    totolAmmount = 0;
    Provider.of<TotalAmmount>(context, listen: false).displayTotolAmmount(0);
    separateItemQuantityList = separateItemQuantities();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("uid");

    if (userId == null) {
      Fluttertoast.showToast(msg: "User ID is null");
      return;
    }

    final response = await http.get(
      Uri.parse(getCart + userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        setState(() {
          cartItems = (data['cart'] as List)
              .map((item) => Items.fromJson(item))
              .toList();
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch cart items");
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to fetch cart items");
    }
  }

  void _handlePayment() async {
    // Show loading spinner while payment is processing
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // The loading spinner
        );
      },
    );

    try {
      // Trigger Paymob payment process
      PaymobPayment.instance.pay(
        context: context,
        currency: "PKR",
        amountInCents: (totolAmmount * 100).toString(), // Convert to cents
        onPayment: (PaymobResponse res) {
          Navigator.of(context).pop(); // Close the loading spinner
          setState(() => response = res);

          if (res.success) {
            // Navigate to the AddressScreen on successful payment
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressScreen(
                  totolAmmount: totolAmmount.toDouble(),
                  sellerUID: widget.sellerUID,
                ),
              ),
            );
          } else {
            // Check for specific issues like token being null
            String errorMessage =
                res.message ?? "Payment failed for an unknown reason.";
            if (errorMessage.contains("Token")) {
              errorMessage =
                  "Payment failed due to an authentication issue. Please try again.";
            }
            Fluttertoast.showToast(msg: errorMessage);
          }
        },
      );

      if (response != null && response!.success) {
        // Navigate to AddressScreen on successful payment
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddressScreen(
              totolAmmount: totolAmmount.toDouble(),
              sellerUID: widget.sellerUID,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Payment failed: ${response?.message ?? 'Unknown error'}");
      }
    } catch (e) {
      Navigator.of(context)
          .pop(); // Close the loading spinner in case of an error
      Fluttertoast.showToast(msg: "Payment error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF261E92),
                Color(0xFF261E92),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            clearCartNow(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
          icon: const Icon(Icons.clear_all),
        ),
        title: const Text(
          "DineHub",
          style: TextStyle(
              fontSize: 24, fontFamily: "Poppins", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [],
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: 'btn1',
              onPressed: () {
                clearCartNow(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MySplashScreen(),
                  ),
                );
                Fluttertoast.showToast(msg: "Cart has been cleared");
              },
              label: const Text(
                "Clear Cart",
                style: TextStyle(
                    color: Colors.white), // Change text color to white
              ),
              backgroundColor: Color(0xFF261E92),
              icon: const Icon(Icons.clear_all,
                  color: Colors.white), // Change icon color to white
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: _handlePayment, // Handle payment on press
              label: const Text(
                "Check Out",
                style: TextStyle(
                    color: Colors.white), // Change text color to white
              ),
              backgroundColor: Color(0xFF261E92),
              icon: const Icon(Icons.navigate_next,
                  color: Colors.white), // Change icon color to white
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(title: "My Cart List"),
          ),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "Total Price: ${amountProvider.tAmmount.toString()} PKR",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Items model = cartItems[index];

                // Debugging statements
                print('model.price: ${model.price}');
                print('separateItemQuantityList: $separateItemQuantityList');

                if (index == 0) {
                  totolAmmount = 0;
                  totolAmmount +=
                      (model.price! * separateItemQuantityList![index]);
                } else {
                  totolAmmount +=
                      (model.price! * separateItemQuantityList![index]);
                }

                if (cartItems.length - 1 == index) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Provider.of<TotalAmmount>(context, listen: false)
                        .displayTotolAmmount(totolAmmount.toDouble());
                  });
                }

                return CartItemDesign(
                  model: model,
                  context: context,
                  quanNumber: separateItemQuantityList![index],
                );
              },
              childCount: cartItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
