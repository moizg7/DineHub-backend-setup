import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/splashScreen/splash_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:paymob_payment/paymob_payment.dart'; // Import Paymob
import 'package:user_app/assistant_methods/assistant_methods.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  initializeCart();
  await Firebase.initializeApp();

  // Initialize Paymob with your API Key, Integration ID, and iFrame ID
  PaymobPayment.instance.initialize(
    apiKey:
        "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRVM056Z3dMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuUkVtVVFFV1V0NkpRcDl2R3hnb3F3UVBTV0pBUnZjZC1Nb3duUmRsbk11RXpMS1UxYnlWWGpXVy1PV3dmRDVTdC1aY3ppRjhudUU3TG1TYXcwZHFlb0E=", // Replace with your Paymob API key
    integrationID: 181099, // Replace with your integration ID
    iFrameID: 190264, // Replace with your iFrame ID
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartItemCounter()),
        ChangeNotifierProvider(create: (context) => TotalAmmount()),
        ChangeNotifierProvider(create: (context) => AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Users App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}
