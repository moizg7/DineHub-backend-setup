import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:user_app/mainScreens/placed_order_screen.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import '../config.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String? addressID;
  final double? totolAmmount;
  final String? sellerUID;

  PaymentMethodScreen({this.addressID, this.totolAmmount, this.sellerUID});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey =
        "pk_test_51QrMlZG2z001wkhcfatk7Ic97YOQ4CcaIxai8LSeCwtecJEVmL3jXvuApMR2iNaFGLsVbnUU1sgwrPFysZT6ITsF00aGSEdyie"; // Replace with your Stripe publishable key
  }

  Future<void> createStripeCheckoutSession() async {
    final url = Uri.parse(createStripeCheckoutSesion);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'items': [
          {
            'name': 'Total Amount',
            'price': widget.totolAmmount,
            'quantity': 1,
          },
        ],
      }),
    );

    // Log the response
    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final clientSecret = data['client_secret'];

      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Your Merchant Name',
          ),
        );

        await Stripe.instance.presentPaymentSheet().then((paymentResult) {
          // Handle successful payment
          print("Payment successful: $paymentResult");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlacedOrderScreen(
                addressID: widget.addressID,
                totolAmmount: widget.totolAmmount,
                sellerUID: widget.sellerUID,
                paymentType: selectedPaymentMethod,
              ),
            ),
          );
        }).catchError((error) {
          // Handle payment error
          print("Error presenting payment sheet: $error");
        });
      } catch (e) {
        print("Error initializing payment sheet: $e");
      }
    } else {
      print("Failed to create Stripe checkout session");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Select Payment Method",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: const Text(
                "Cash on Delivery",
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              leading: Radio<String>(
                value: "Cash on Delivery",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                "Wallet",
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              leading: Radio<String>(
                value: "Wallet",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                "Stripe",
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              leading: Radio<String>(
                value: "Stripe",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedPaymentMethod == null
                  ? null
                  : () {
                      if (selectedPaymentMethod == "Stripe") {
                        createStripeCheckoutSession();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlacedOrderScreen(
                              addressID: widget.addressID,
                              totolAmmount: widget.totolAmmount,
                              sellerUID: widget.sellerUID,
                              paymentType: selectedPaymentMethod,
                            ),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF261E92),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
