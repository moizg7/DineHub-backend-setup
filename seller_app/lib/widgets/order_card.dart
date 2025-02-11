import 'package:flutter/material.dart';
import 'package:seller_app/model/items.dart';
import 'package:seller_app/widgets/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<dynamic>? data;
  final String? orderId;
  final List<String>? seperateQuantitiesList;
  final String? sellerName;
  final double? totalPrice;

  const OrderCard({
    super.key,
    this.itemCount,
    this.data,
    this.orderId,
    this.seperateQuantitiesList,
    this.sellerName,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID : $orderId",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Poppins",
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "User Name : $sellerName",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                itemCount: itemCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (c, index) {
                  Items model =
                      Items.fromJson(data![index] as Map<String, dynamic>);
                  return placedOrderDesignWidget(
                      model, context, seperateQuantitiesList?[index]);
                },
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
                    "Quantity x",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  Expanded(
                    child: Text(
                      seperateQuantitiesList ?? '',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
