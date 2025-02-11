import 'package:flutter/material.dart';
import 'package:user_app/mainScreens/search_screen.dart'; // Import the SearchScreen

import '../cake/cakeItems.dart';
import '../restaurent/restaurent1.dart';
import '../restaurent/restaurent2.dart';
import '../restaurent/restaurent3.dart';
import '../restaurent/restaurent4.dart';
import '../restaurent/restaurent5.dart';
import 'HomeLargeItems.dart';

import 'HomePageItems3.dart';
import 'HomePageMediumItems.dart';
import 'HomepageItems4.dart';

void main(List<String> args) {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DiningPagePageState();
}

class _DiningPagePageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.deepPurple),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.search, color: Colors.deepPurple),
                    ),
                    Text(
                      "Search for sellers...",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 250,
            width: double.infinity,
            child: HomeLargeItems(),
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              'EXPLORE',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          const SizedBox(
            height: 180,
            width: double.infinity,
            child: HomeMediumItems(),
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              'WHATS ON YOUR MIND?',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          const SizedBox(
            height: 100,
            width: double.infinity,
            child: HomePageItems3(),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'OUR RESTAURENTS',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          // Removed hardcoded restaurants
        ],
      ),
    );
  }
}
