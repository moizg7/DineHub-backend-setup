import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/widgets/app_bar.dart';
import '../assistant_methods/assistant_methods.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(sellerUID: widget.model!.sellerUID),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.model!.thumbnailUrl.toString(),
                height: 250, // Set a fixed height for the image
                fit: BoxFit
                    .cover, // Ensure the image covers the specified height
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberInputPrefabbed.roundedButtons(
                controller: counterTextEditingController,
                incDecBgColor: Color.fromARGB(255, 117, 112, 139),
                min: 1,
                max: 9,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Rs ${widget.model!.price}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  int itemCounter =
                      int.parse(counterTextEditingController.text);

                  List<String> separateItemIdsList = separateItemIds();

                  separateItemIdsList.contains(widget.model!.itemId)
                      ? Fluttertoast.showToast(msg: "Item is already in cart")
                      : addItemToCart(
                          widget.model!.itemId, context, itemCounter);
                },
                child: Container(
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
                  height: 50,
                  width: MediaQuery.of(context).size.width - 13,
                  child: const Center(
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Poppins"),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
