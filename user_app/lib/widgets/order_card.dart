import 'package:flutter/material.dart';
import 'package:user_app/models/items.dart';
import '../mainScreens/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<dynamic>? data;
  final String? orderId;
  final List<String>? seperateQuantitiesList;
  final String? sellerName;
  final String? sellerImage;
  final double? totalPrice;

  const OrderCard({
    super.key,
    this.itemCount,
    this.data,
    this.orderId,
    this.seperateQuantitiesList,
    this.sellerName,
    this.sellerImage,
    this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(orderId: orderId)));
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.white54,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height:
            itemCount! * 150, // Increase height to accommodate larger content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                sellerImage != null
                    ? Image.network(
                        sellerImage!,
                        width: 70, // Increase width
                        height: 70, // Increase height
                      )
                    : Container(
                        width: 70, // Increase width
                        height: 70, // Increase height
                        color: Colors.grey,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                const SizedBox(width: 10),
                Text(
                  sellerName ?? 'No Seller',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20, // Increase font size
                    fontFamily: "Acme",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (c, index) {
                  Items model =
                      Items.fromJson(data![index] as Map<String, dynamic>);
                  return placedOrderDesignWidget(
                      model, context, seperateQuantitiesList?[index]);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Total: Rs ",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                Text(
                  totalPrice?.toString() ?? '0',
                  style: const TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget placedOrderDesignWidget(
    Items model, BuildContext context, String? seperateQuantitiesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        model.thumbnailUrl != null
            ? Image.network(
                model.thumbnailUrl!,
                width: 120,
              )
            : Container(
                width: 120,
                color: Colors.grey,
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.title ?? 'No Title',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Rs ",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  Text(
                    model.price?.toString() ?? '0',
                    style: const TextStyle(color: Colors.blue, fontSize: 18),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text(
                    "x",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  Expanded(
                    child: Text(
                      seperateQuantitiesList ?? '',
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 30,
                          fontFamily: "Poppins"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
