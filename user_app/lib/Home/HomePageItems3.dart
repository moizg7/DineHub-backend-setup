import 'package:flutter/material.dart';
import '../mainScreens/search_screen.dart';

class HomePageItems3 extends StatelessWidget {
  const HomePageItems3({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PageView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/burger1.jpeg'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text('Burger')
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/pizza7.jpeg'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text('Pizza')
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/cake.jpeg'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text('Cake')
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/softdrink.png'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text('Soft Drinks')
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
