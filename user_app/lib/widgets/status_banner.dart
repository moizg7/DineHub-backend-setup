import 'package:flutter/material.dart';
import 'package:user_app/mainScreens/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final String? orderStatus;

  const StatusBanner({super.key, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData? iconData;

    if (orderStatus == "pending") {
      iconData = Icons.hourglass_empty;
      message = "Order Placed";
    } else if (orderStatus == "accepted") {
      iconData = Icons.check_circle;
      message = "Order Accepted";
    } else if (orderStatus == "on way") {
      iconData = Icons.local_shipping;
      message = "Order On the Way";
    } else if (orderStatus == "delivered") {
      iconData = Icons.done;
      message = "Parcel Delivered";
    } else {
      iconData = Icons.error;
      message = "Order Status Unknown";
    }

    return Container(
      width: double.infinity, // Ensure full width
      height: AppBar().preferredSize.height +
          MediaQuery.of(context)
              .padding
              .top, // Adjust height to include status bar
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
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 10.0,
          right: 10.0), // Add padding to avoid camera notch
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Text(
            message,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: "Poppins"),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
