import 'package:flutter/material.dart';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/address_screen.dart';
import 'package:user_app/mainScreens/history_screen.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import 'package:user_app/mainScreens/my_orders_screen.dart';
import 'package:user_app/mainScreens/search_screen.dart';
import 'package:user_app/mainScreens/wallet.dart';
import 'package:user_app/mainScreens/welcome.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 20, fontFamily: "Poppins"),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Home",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.reorder,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "My Orders",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOrdersScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "History",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.wallet,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Wallet",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.add_location,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Add new Address",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Sign Out",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const welcome()));
                    });
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
