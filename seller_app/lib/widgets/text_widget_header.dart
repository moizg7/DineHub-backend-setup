import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  final String title;

  TextWidgetHeader({required this.title});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(38, 38, 247, 1),
              Color.fromRGBO(46, 46, 252, 1)
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              letterSpacing: 1,
              color: Colors.white),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80; // Adjusted to match the height of the container
  @override
  double get minExtent => 80; // Adjusted to match the height of the container

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Return true to always rebuild the header
  }
}
