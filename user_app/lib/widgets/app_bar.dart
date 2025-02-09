import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/mainScreens/cart_screen.dart';

class MyAppbar extends StatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? sellerUID;

  MyAppbar({this.bottom, this.sellerUID});
  @override
  State<MyAppbar> createState() => _MyAppbarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppbarState extends State<MyAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white)),
      title: const Text(
        "DineHub",
        style:
            TextStyle(fontSize: 24, fontFamily: "Poppins", color: Colors.white),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CartScreen(sellerUID: widget.sellerUID)));
              },
              icon: const Icon(
                Icons.shopping_cart_checkout,
                color: Colors.white,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.brightness_1, size: 20, color: Colors.white),
                  Consumer<CartItemCounter>(
                    builder: (context, counter, c) {
                      return Text(
                        counter.count.toString(),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 54, 105, 244),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
