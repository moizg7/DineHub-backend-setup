import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/model/menus.dart';
import 'package:seller_app/uploadScreens.dart/menus_upload_screen.dart';
import 'package:seller_app/widgets/info_design.dart';
import 'package:seller_app/widgets/my_drower.dart';
import 'package:seller_app/config.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:seller_app/widgets/text_widget_header.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Menus> _menusList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  // Fetch menus from the Node.js backend
  Future<void> fetchMenus() async {
    final sellerUID = sharedPreferences!.getString("uid");
    final url = Uri.parse(getmenu + sellerUID!);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            _menusList = (data['menus'] as List)
                .map((json) => Menus.fromJson(json))
                .toList();
          });
        } else {
          throw Exception('Failed to load menus: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load menus');
      }
    } catch (error) {
      print("Error fetching menus: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
                  builder: (context) => const MenusUploadScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.post_add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: TextWidgetHeader(title: "Menus"),
          ),
          _isLoading
              ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
              : _menusList.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "No menus available",
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
                        Menus model = _menusList[index];
                        print(
                            "HomeScreen: menuId = ${model.menuId}"); // Debug print
                        return InfoDesignWidget(
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
