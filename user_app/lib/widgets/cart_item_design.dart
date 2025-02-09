import 'package:flutter/material.dart';
import '../models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({
    super.key,
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 2, horizontal: 4), // Adjust padding
        child: Container(
          height: 120, // Adjust height
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                width: 100,
                height: 100,
              ),
              const SizedBox(
                width: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                  const SizedBox(
                    height: 2, // Adjust spacing
                  ),
                  Row(
                    children: [
                      const Text(
                        "x ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Poppins-Italic",
                        ),
                      ),
                      Text(
                        widget.quanNumber.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Poppins-Bold",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2, // Adjust spacing
                  ),
                  Row(
                    children: [
                      const Text(
                        "Price : ",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                      const Text(
                        "Rs ",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.blue),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
