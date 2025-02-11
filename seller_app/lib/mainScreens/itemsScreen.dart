import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/models/items.dart';
import 'package:seller_app/uploadScreens.dart/items_upload_screen.dart';
import 'package:seller_app/widgets/items_design.dart';
import 'package:seller_app/widgets/my_drower.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seller_app/config.dart';

import '../model/menus.dart';
import '../widgets/text_widget_header.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  const ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Items> _itemsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // Fetch items from the Node.js backend
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
      } finally {
        setState(() {
          _isLoading = false;
        });
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
                Color(0xFF261E92),
                Color(0xFF261E92),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: "Poppins",
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ItemsUploadScreen(model: widget.model)));
              },
              icon: const Icon(
                Icons.library_add,
                color: Colors.white,
              ))
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              delegate: TextWidgetHeader(
                  title: "My ${widget.model!.menuTitle}'s Items")),
          _isLoading
              ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
              : _itemsList.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "No items available",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (context) =>
                          const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Items model = _itemsList[index];
                        return ItemDesignWidget(
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
