import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/mainScreens/cart_screen.dart';

class CustomTopBar extends StatelessWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomTopBar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 61,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF261E92),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
                icon: Icon(
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
                    Icon(Icons.brightness_1, size: 20, color: Colors.white),
                    Consumer<CartItemCounter>(
                      builder: (context, counter, c) {
                        return Text(
                          counter.count.toString(),
                          style: TextStyle(
                            color: Color.fromARGB(255, 54, 105, 244),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
