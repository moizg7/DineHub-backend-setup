import 'package:flutter/material.dart';
import 'package:paymob_payment/paymob_payment.dart';

class PaymentService {
  PaymentService() {
    // Initialize Paymob with your credentials
    PaymobPayment.instance.initialize(
      apiKey: "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRVM056Z3dMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuUkVtVVFFV1V0NkpRcDl2R3hnb3F3UVBTV0pBUnZjZC1Nb3duUmRsbk11RXpMS1UxYnlWWGpXVy1PV3dmRDVTdC1aY3ppRjhudUU3TG1TYXcwZHFlb0E=", // Replace with your actual API key
      integrationID: 181099, 
      iFrameID: 190264, 
      
    );
  }

  Future<PaymobResponse?> processPayment(BuildContext context, String amount, String currency) async {
    PaymobResponse? response;
    try {
      response = await PaymobPayment.instance.pay(
        context: context,
        currency: currency,
        amountInCents: (double.parse(amount) * 100).toString(), // Convert to cents
        onPayment: (PaymobResponse res) {
          // Handle payment response
          if (res.success) {
            // Payment was successful
            print("Payment successful: ${res.transactionID}");
          } else {
            // Payment failed
            print("Payment failed: ${res.message}");
          }
        },
      );
      return response;
    } catch (e) {
      throw Exception('Payment processing error: $e');
    }
  }
}
