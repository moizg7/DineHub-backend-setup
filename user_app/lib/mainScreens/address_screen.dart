import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/mainScreens/save_address_screen.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/address_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../assistant_methods/address_changer.dart';
import '../config.dart';
import '../global/global.dart';

class AddressScreen extends StatefulWidget {
  final double? totolAmmount;
  final String? sellerUID;

  AddressScreen({this.totolAmmount, this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Address> addressList = [];

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("uid");

    if (userId == null) {
      Fluttertoast.showToast(msg: "User ID is null");
      return;
    }

    final response = await http.get(
      Uri.parse(getAddresses + userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        setState(() {
          addressList = (data['addresses'] as List)
              .map((item) => Address.fromJson(item))
              .toList();
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch addresses");
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to fetch addresses");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "DineHub",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SaveAddressScreen()));
          // save address
        },
        label: const Text(
          "Add New Address",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins"), // Change text color to white
        ),
        backgroundColor: Color(0xFF261E92),
        icon: const Icon(
          Icons.add_location,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Select Address",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
              child: addressList.isEmpty
                  ? Center(
                      child: circularProgress(),
                    )
                  : ListView.builder(
                      itemCount: addressList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return AddressDesign(
                          curretIndex: address.count,
                          value: index,
                          addressID: addressList[index].id,
                          totolAmmount: widget.totolAmmount,
                          sellerUID: widget.sellerUID,
                          model: addressList[index],
                        );
                      },
                    ),
            );
          })
        ],
      ),
    );
  }
}
