import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services package

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;

  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom, this.title}) {
    // Set the status bar color when the SimpleAppBar is created
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF261E92), // Set the status bar color
    ));
  }

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);

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
      title: Text(
        title!,
        style: const TextStyle(
            fontSize: 24, fontFamily: "Poppins", color: Colors.white),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(
        color: Colors.white, // Change this to your desired color
      ),
      actions: [],
    );
  }
}
