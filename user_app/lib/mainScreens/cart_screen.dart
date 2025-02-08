import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/mainScreens/address_screen.dart';
import 'package:user_app/models/items.dart';
import 'package:paymob_payment/paymob_payment.dart';
import '../assistant_methods/total_ammount.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/cart_item_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';
import '../services/payment_service.dart'; // Import PaymentService

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  const CartScreen({super.key, this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
              colors: [Colors.red, Colors.redAccent],
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
          },
          icon: const Icon(Icons.clear_all),
        ),
        title: const Text(
          "I-Eat",
          style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [],
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
              label: const Text("Clear Cart"),
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.clear_all),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: _handlePayment, // Handle payment on press
              label: const Text("Check Out"),
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.navigate_next),
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
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemId", whereIn: separateItemIds())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data!.docs.isEmpty
                      ? Container()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Items model = Items.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>,
                              );

                              if (index == 0) {
                                totolAmmount = 0;
                                totolAmmount += (model.price! *
                                    separateItemQuantityList![index]);
                              } else {
                                totolAmmount += (model.price! *
                                    separateItemQuantityList![index]);
                              }

                              if (snapshot.data!.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmmount>(context,
                                          listen: false)
                                      .displayTotolAmmount(
                                          totolAmmount.toDouble());
                                });
                              }

                              return CartItemDesign(
                                model: model,
                                context: context,
                                quanNumber: separateItemQuantityList![index],
                              );
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
