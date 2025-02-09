import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/mainScreens/placed_order_screen.dart';
import 'package:user_app/models/address.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? curretIndex;
  final int? value;
  final String? addressID;
  final double? totolAmmount;
  final String? sellerUID;

  const AddressDesign(
      {super.key,
      this.model,
      this.curretIndex,
      this.value,
      this.addressID,
      this.totolAmmount,
      this.sellerUID});

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: const Color.fromARGB(255, 151, 139, 143).withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.value!,
                  groupValue: widget.curretIndex!,
                  activeColor: Color(0xFF261E92),
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                    print(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text(
                                "Room No ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins"),
                              ),
                              Text(widget.model!.roomNo.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Hostel ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins"),
                              ),
                              Text(widget.model!.hostel.toString()),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlacedOrderScreen(
                                    addressID: widget.addressID,
                                    totolAmmount: widget.totolAmmount,
                                    sellerUID: widget.sellerUID,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF261E92),
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        color: Colors.white, // Change text color to white
                        fontFamily: "Poppins", // Use Poppins font
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
