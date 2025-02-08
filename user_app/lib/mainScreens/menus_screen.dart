import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/menus_design.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/text_widget_header.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/config.dart';

import '../models/sellers.dart';
import '../splashScreen/splash_screen.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  const MenusScreen({super.key, this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  List<Menus> _menusList = [];

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  // Fetch menus from the Node.js backend
  Future<void> fetchMenus() async {
    final sellerUID = widget.model!.sellerUID;
    print("Fetching menus for seller: $sellerUID");
    final url = Uri.parse(getmenu + sellerUID!);
    print("URL: ${url.toString()}");

    try {
      final response = await http.get(url);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded data: $data");
        if (data['status'] == true) {
          setState(() {
            _menusList = (data['menus'] as List)
                .map((json) => Menus.fromJson(json))
                .toList();
            print("Menus loaded: ${_menusList.length}");
          });
        } else {
          throw Exception('Failed to load menus: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load menus');
      }
    } catch (error) {
      print("Error fetching menus: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(2, 3, 129, 1),
                Color.fromRGBO(2, 3, 129, 1)
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "DineHub",
          style: TextStyle(
            fontFamily: "Train",
            fontSize: 40,
            color: Colors.white, // Change this to your desired color
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate:
                TextWidgetHeader(title: "${widget.model!.sellerName} Menus"),
          ),
          _menusList.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
              : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Menus model = _menusList[index];
                    return MenusDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                  itemCount: _menusList.length,
                ),
        ],
      ),
    );
  }
}
