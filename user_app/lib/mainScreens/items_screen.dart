import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/items_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/text_widget_header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_app/config.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  const ItemsScreen({super.key, this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Items> _itemsList = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final menuId = widget.model?.menuId;
    print("Menu ID in ItemsScreen: $menuId"); // Debug print
    if (menuId != null) {
      final url = Uri.parse(getitem + menuId);
      print("Fetching items from URL: $url"); // Debug print

      try {
        final response = await http.get(url);
        print("Response status code: ${response.statusCode}"); // Debug print
        print("Response body: ${response.body}"); // Debug print

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print("Response data: $data"); // Debug print
          if (data['status'] == true) {
            setState(() {
              _itemsList = (data['items'] as List)
                  .map((json) => Items.fromJson(json))
                  .toList();
            });
            print("Items list updated: $_itemsList"); // Debug print
          } else {
            throw Exception('Failed to load items: ${data['message']}');
          }
        } else {
          throw Exception('Failed to load items');
        }
      } catch (error) {
        print("Error fetching items: $error");
      }
    } else {
      throw Exception('Menu ID is null');
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
                TextWidgetHeader(title: "Items of ${widget.model!.menuTitle}"),
          ),
          _itemsList.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
              : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Items model = _itemsList[index];
                    return ItemsDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                  itemCount: _itemsList.length,
                ),
        ],
      ),
    );
  }
}
