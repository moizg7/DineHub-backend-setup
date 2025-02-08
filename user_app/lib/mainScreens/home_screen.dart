import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/Home/home.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';

import 'package:user_app/models/sellers.dart';
import 'package:user_app/widgets/sellers_design.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/config.dart'; // Make sure you have the API endpoint defined here
import 'package:user_app/widgets/hometop.dart'; // Import CustomTopBar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Sellers> _sellersList = [];

  @override
  void initState() {
    super.initState();
    fetchSellers();
    clearCartNow(context);
  }

  Future<void> fetchSellers() async {
    final url = Uri.parse(getSellers);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _sellersList = data.map((json) => Sellers.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load sellers');
      }
    } catch (error) {
      print("Error fetching sellers: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomTopBar(
                  title: 'Homepage',
                  scaffoldKey: _scaffoldKey,
                ),
                Home(),
                // Remove the CarouselSlider if it's not needed
              ],
            ),
          ),
          _sellersList.isEmpty
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Sellers model = _sellersList[index];
                      return SellersDesignWidget(
                        model: model,
                        context: context,
                      );
                    },
                    childCount: _sellersList.length,
                  ),
                ),
        ],
      ),
    );
  }
}
